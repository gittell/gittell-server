fs = require "fs"
async = require "async"
db = require "../lib/models"

datetime = new Date().toISOString().split('.').shift().replace(/[^\d]/g, '')

async.forEach(
  [ "User", "Site", "Activity", "Identity", "AccessToken" ],
  (model, cb) ->
    db[model].all().then (records) ->
      data = JSON.stringify(records)
      fs.mkdir __dirname + "/backup/#{datetime}", (err, res) ->
        fs.writeFile __dirname + "/backup/#{datetime}/#{model.toLowerCase()}.json", data, ->
          cb()
    .catch (err) -> cb(err)
,
  (err) ->
    console.error err if err
    process.exit(0)
)
