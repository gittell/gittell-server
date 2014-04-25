app = require "../app"

errors =
  INVALID_TOKEN:
    status: 400
    details: "Invalid access token has been supplied"
  AUTHORIZATION_REQUIRED:
    status: 401
    details: "Authorization required to access the resource"
  ACCESS_NOT_ALLOWED:
    status: 403
    details: "Access not allowed"
  NOT_FOUND:
    status: 404
    details: "Requested resource not found"
  UNKNOWN_ERROR:
    status: 500
    details: "Unknown error"

app.use (err, req, res, next) ->
  console.error err.stack
  # API Error Handling 
  if /^\/api\//.test(req.url)
    message = err.message
    error = errors[message] || errors["UNKNOWN_ERROR"]
    res.send error.status,
      error:
        message: message
        details: error.details
  else
    next(err)

