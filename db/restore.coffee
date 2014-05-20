fs = require "fs"
path = require "path"
async = require "async"
program = require "commander"
db = require "../lib/models"

program.parse(process.argv);
backupDir = if program.args[0] then path.resolve(process.cwd(), program.args[0]) else __dirname + "/backup"

async.forEach(
  [ "User", "Site", "Activity", "Identity" ],
  (model, cb) ->
    data = fs.readFileSync "#{backupDir}/#{model.toLowerCase()}.json", "utf-8"
    records = JSON.parse(data)
    db[model].destroy({}, { truncate: true }).then ->
      db[model].bulkCreate(records)
    .then ->
      db[model].max('id')
    .then (maxId) ->
      tableName = db[model].tableName
      idSeqName = "#{tableName}_id_seq"
      db.sequelize.query "ALTER SEQUENCE \"#{idSeqName}\" RESTART WITH #{maxId+1};"
    .then -> cb()
    .catch(cb)
,
  (err) ->
    console.error err if err
    process.exit(0)
)
