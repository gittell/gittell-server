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
,
  classMethods:
    groupBy: (groupProp, condition) ->
      Activity.findAll
        where: condition
        attributes: [
          groupProp
          [ sequelize.fn("max", sequelize.col("id")), "id" ]
          [ sequelize.fn("sum", sequelize.col("duration")), "totalDuration" ]
        ]
        group: [ groupProp, "date" ]
      .then (summaries) ->
        ids = summaries.map (s) -> s.values.id
        Activity.findAll
          where:
            id: ids
          include: [ Site ]
        .then (activities) ->
          activities = activities.reduce (o, a) ->
            o[a.id] = a
            o
          , {}
          summaries.map (s) ->
            summary = s.values
            activity = activities[summary.id]
            summary.site = activity.site
            summary.title = activity.title
            summary.projectUrl = activity.projectUrl
            summary.projectTitle = activity.projectTitle
            summary.date = activity.date
            summary.totalDuration = Number(summary.totalDuration)
            delete summary.id
            summary

Activity.belongsTo(User, { foreignKey: "userId" })
Activity.belongsTo(Site, { foreignKey: "siteId" })


