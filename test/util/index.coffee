Q = require "q"
db = require "../../lib/models"

module.exports =

  accessToken: null

  setup: ->
    db.sequelize.sync()

  loginAs: (id) ->
    db.AccessToken.find 
      where:
        userId: id
    .then (rec) =>
      @accessToken = rec && rec.id

  teardown: ->
    Q(true)
