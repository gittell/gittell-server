{ Sequelize, sequelize, User } = require "./index"

AccessToken = module.exports = sequelize.define "AccessToken",
  id:
    type: Sequelize.STRING
    primaryKey: true
  clientId:
    type: Sequelize.STRING
    allowNull: false

AccessToken.belongsTo(User, { foreignKey: "userId" })

