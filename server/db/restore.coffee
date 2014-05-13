fs = require "fs"
async = require "async"
db = require "../lib/models"

async.forEach(
  [ "User", "Site", "Activity", "Identity" ],
  (model, cb) ->
    data = fs.readFileSync __dirname + "/backup/#{model.toLowerCase()}.json", "utf-8"
    records = JSON.parse(data)
    db[model].bulkCreate(records)
      .then -> cb()
      .catch (err) -> cb(err)
,
  (err) ->
    console.error err if err
    process.exit(0)
)
