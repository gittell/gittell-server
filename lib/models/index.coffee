Sequelize = require "sequelize"

sequelize = new Sequelize process.env.DATABASE_URL || 'postgres://localhost/database',
  protocol: "postgres"
  native: true

db = module.exports =
  Sequelize: Sequelize
  sequelize: sequelize

db.User = require "./user"
db.Identity = require "./identity"
db.AccessToken = require "./access-token"
db.Site = require "./site"
db.Activity = require "./activity"

