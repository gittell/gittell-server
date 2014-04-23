{ Sequelize, sequelize, User } = require("./index")

Site = module.exports = sequelize.define "Site",
  url:
    type: Sequelize.STRING
    allowNull: false
    validation:
      isUrl: true
  title:
    type: Sequelize.STRING
    allowNull: false
  iconUrl:
    type: Sequelize.STRING
    allowNull: false
    validation:
      isUrl: true
  manifestUrl:
    type: Sequelize.STRING
  manifest:
    type: Sequelize.TEXT
    get: ->
      v = @getDataValue('manifest')
      try
        JSON.parse(v)# ...
      catch e
        ""
    set: (v) ->
      json = JSON.stringify(v || {})
      @setDataValue('manifest', json)
