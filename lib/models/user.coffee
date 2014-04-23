{ Sequelize, sequelize } = require("./index")

User = module.exports = sequelize.define "User",
  username:
    type: Sequelize.STRING
    allowNull: false
    unique: true
    validate:
      is: [ "^[\\w\\-]+$" ]
  displayName:
    type: Sequelize.STRING
    allowNull: false
    validate:
      notEmpty: true
  iconUrl:
    type: Sequelize.STRING
    allowNull: false
    validate:
      isUrl: true
      notEmpty: true
  isAdmin:
    type: Sequelize.BOOLEAN
    defaultValue: false


