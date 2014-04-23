{ Sequelize, sequelize, User } = require "./index"

Identity = module.exports = sequelize.define "Identity",
  provider:
    type: Sequelize.STRING
    allowNull: false
  identifier:
    type: Sequelize.STRING
    allowNull: false
  userInfo:
    type: Sequelize.TEXT
    get: ->
      v = @getDataValue('userInfo')
      try
        JSON.parse(v)# ...
      catch e
        ""
    set: (v) ->
      json = JSON.stringify(v || {})
      @setDataValue('userInfo', json)

Identity.belongsTo(User, { foreignKey: "userId" })

