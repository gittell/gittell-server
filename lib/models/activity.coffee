{ Sequelize, sequelize, User, Site } = require("./index")

Activity = module.exports = sequelize.define "Activity",
  url:
    type: Sequelize.STRING
    allowNull: false
  title:
    type: Sequelize.STRING
    allowNull: false
  projectUrl:
    type: Sequelize.STRING
    allowNull: true
  projectTitle:
    type: Sequelize.STRING
    allowNull: true
  since:
    type: Sequelize.BIGINT
    allowNull: false
  duration:
    type: Sequelize.INTEGER
    allowNull: false
  date:
    type: Sequelize.STRING
    validate:
      is: /^\d{8}$/

Activity.belongsTo(User, { foreignKey: "userId" })
Activity.belongsTo(Site, { foreignKey: "siteId" })

