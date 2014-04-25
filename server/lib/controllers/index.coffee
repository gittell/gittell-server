app = require "../app"

require "./auth"
require "./user"
require "./site"
require "./activity"
require "./error"

app.get "/", (req, res) ->
  res.send "<body></body>"

