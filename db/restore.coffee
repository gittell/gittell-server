fs = require "fs"
path = require "path"
Q = require "q"
program = require "commander"
db = require "../lib/models"

loadData = (dataDir, truncate) ->
  Q.all( 
    [ "User", "Site", "Activity", "Identity", "AccessToken" ].map (model) ->
      data = fs.readFileSync "#{dataDir}/#{model.toLowerCase()}.json", "utf-8"
      records = JSON.parse(data)
      db[model].destroy({}, { truncate: truncate }).then ->
        db[model].bulkCreate(records)
      .then ->
        db[model].max('id')
      .then (maxId) ->
        unless model == "AccessToken"
          tableName = db[model].tableName
          idSeqName = "#{tableName}_id_seq"
          db.sequelize.query "ALTER SEQUENCE \"#{idSeqName}\" RESTART WITH #{maxId+1};"
  )

module.exports.loadData = loadData


if require.main == module
  program.parse(process.argv);
  backupDir = if program.args[0] then path.resolve(process.cwd(), program.args[0]) else __dirname + "/backup"
  loadData(backupDir, true).then ->
    process.exit(0)
  .catch (err) ->
    process.exit()
