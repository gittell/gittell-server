app = require "../app"
config = require "../config"

app.get "/", (req, res) ->
  res.render "index",
    baseUrl: config.gittell.clientAssetBaseUrl

app.get "/callback.html", (req, res) ->
  res.render "callback",
    baseUrl: config.gittell.clientAssetBaseUrl