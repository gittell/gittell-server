crypto = require "crypto"
querystring = require "querystring"
request = require "request"
url = require "url"
async = require "async"
app = require "../app"
db = require "../models"
config = require "../config"

###
# OAuth authorization
###
app.get "/oauth2/authorize", (req, res) ->
  responseType = req.param("response_type")
  clientId = req.param("client_id")
  redirectUri = req.param("redirect_uri")
  state = req.param("state")
  clientConfig = config.oauth2[clientId]
  return res.send(error: "No client registered for #{clientId}", 400) unless clientConfig 
  return res.send(error: "Redirect URI mismatch", 400) unless clientConfig.redirectUri == redirectUri
  return res.send(error: "Only supports response_type='token'", 400) unless responseType == "token"
  if req.session.authUserId
    authUserId = req.session.authUserId
    db.AccessToken.find
      where:
        clientId: clientId
        userId: authUserId
    .then (accessToken) ->
      accessToken or
        db.AccessToken.create
          id: crypto.randomBytes(48).toString('hex')
          clientId: clientId
          userId: authUserId
    .then (accessToken) ->
      console.log "redirecting.. " + redirectUri
      res.redirect redirectUri + "#" + querystring.stringify
        access_token: accessToken.id
        state: state
    , (err) ->
      res.send(error: err, 500)
  else
    parsed = url.parse req.url
    res.redirect "/auth/login?return=" + encodeURIComponent(parsed.path)

###
# Revoke issued OAuth token
###
app.get "/oauth2/revoke", (req, res, error) ->
  token = req.param('token')
  db.AccessToken.find(token)
    .then (accessToken) ->
      accessToken.remove() if accessToken
    .then () ->
      res.send { "message": "revoked successfully" }
    .catch (err) ->
      res.send { "error": err.message }, 503

###
# User Login (redirect to github auth page)
###
app.get "/auth/login", (req, res) ->
  providerName = "github"
  rand = crypto.randomBytes(48).toString('hex')
  returnTo = req.param("return")
  returnTo = if returnTo && /^\/[\w\-]/.test(returnTo) then returnTo else "/"
  state = req.session.state = rand + ";" + returnTo
  console.log "state: " + state
  clientConfig = config[providerName]
  authzUrl = clientConfig.authzUrl + "?" + querystring.stringify
    response_type: "code"
    client_id: clientConfig.clientId
    redirect_uri: clientConfig.redirectUri
    state: state
    scope: "user"
  req.session.save (err) ->
    console.log "redirecting to: ", authzUrl
    res.redirect authzUrl

###
# User Session Logout
###
app.get "/auth/logout", (req, res) ->
  req.session.authUserId = null
  req.session.save (err) -> res.redirect "/"

###
# Github OAuth callback
###
app.get "/auth/github/callback", (req, res) ->
  code = req.param("code")
  state = req.param("state")
  return res.send(error: "No authorization code passed to parameter", 400) unless code
  return res.send(error: "State does not much") unless state == req.session.state
  providerName = "github"
  clientConfig = config[providerName]
  async.waterfall [
    (cb) ->
      request
        method: "POST"
        url: clientConfig.tokenUrl,
        headers:
          "content-type": "application/json"
        body:
          grant_type: "authorization_code"
          code: code
          client_id: clientConfig.clientId
          client_secret: clientConfig.clientSecret
          redirect_uri: clientConfig.redirectUri
        json: true
      , cb
    (response, body, cb) ->
      accessToken = body.access_token
      request
        method: "GET"
        url: clientConfig.userInfoUrl
        headers:
          Authorization: "Bearer #{accessToken}"
          "User-Agent": "App Client #{clientConfig.clientId}"
        json: true
      , cb
    (response, userInfo, cb) ->
      authUserId = null
      db.Identity.find 
        where:
          provider: providerName
          identifier: String(userInfo.id)
        include: [ db.User ]
      .then (identity) ->
        if identity
          authUserId = identity.user.id
          console.log "updating userinfo"
          identity.userInfo = userInfo
          identity.save()
        else
          console.log "creating new user"
          user = db.User.build
            username: userInfo.login
            displayName: userInfo.name
            iconUrl: userInfo.avatar_url
          user.save().then (u) ->
            authUserId = u.id
            console.log "binding new identity"
            identity = db.Identity.build
              provider: providerName
              identifier: String(userInfo.id)
              userInfo: userInfo
              userId: u.id
            identity.save()
      .then (ret) ->
        cb(null, authUserId)
      , (err) ->
        cb(err)
  ],
    (err, authUserId) ->
      return res.send(error: err, 500) if err
      req.session.authUserId = authUserId
      returnTo = state.split(";").pop()
      console.log "redirection to #{returnTo}"
      returnTo = if returnTo && /^\/[\w\-]/.test(returnTo) then returnTo else "/"
      res.redirect returnTo


###
# API Authorization using access token
###
app.all "/api/*", (req, res, next) ->
  token = /^Bearer\s+(\w+)$/.exec(req.header('authorization'))
  token = token && token[1]
  if token
    db.AccessToken.find
      where:
        id: token
      include: [ db.User ]
    .then (accessToken) ->
      if accessToken && accessToken.user
        req.user = accessToken.user
        next()
      else
        next(new Error("INVALID_TOKEN"))
    .catch (err) ->
      next(err)
  else
    next(new Error("AUTHORIZATION_REQUIRED"))



