db = require "../lib/models"

method = process.argv[2] || "up"
console.log "method: ", method

db.sequelize.getMigrator
  path: __dirname + "/migrations"
  filesFilter: /\.coffee$/
.migrate { method: method }
.then (res) ->
  console.log res
  process.exit(0)

