db = require "../lib/models"

force = process.argv[2] == "force"

db.sequelize.sync(force)
  .then (res) ->
    console.log res
    process.exit(0)

