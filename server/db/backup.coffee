fs = require "fs"
async = require "async"
db = require "../lib/models"

async.forEach(
  [ "User", "Site", "Activity", "Identity" ],
  (model, cb) ->
    db[model].all().then (records) ->
      data = JSON.stringify(records)
      fs.writeFile __dirname + "/backup/#{model.toLowerCase()}.json", data, cb
    .catch (err) -> cb(err)
,
  (err) ->
    console.error err if err
    process.exit(0)
)
