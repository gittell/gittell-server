app = require "../app"
db = require "../models"

###
# List sites
###
app.get "/api/site", (req, res) ->
  db.Site.findAll().then (sites) ->
    res.send(sites)

