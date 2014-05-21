Q = require "q"
path = require "path"
db = require "../../lib/models"
loader = require "../../db/restore"

module.exports =

  accessToken: null

  setup: ->
    dataDir = path.join __dirname, "../fixture"
    db.sequelize.sync().then ->
      loader.loadData(dataDir, true)

  loginAs: (id) ->
    db.AccessToken.find 
      where:
        userId: id
    .then (rec) =>
      @accessToken = rec && rec.id

  teardown: ->
    Q(true)
