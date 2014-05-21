app = require "../app"
config = require "../config"

app.get "/", (req, res) ->
  res.render "index",
    baseUrl: config.gittell.clientAssetBaseUrl
