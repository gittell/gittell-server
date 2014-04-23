app = require "../app"
db = require "../models"

 
###
# Show activity summary of user
###
app.get "/api/user/:userId/activity/summary", (req, res, error) ->
  query =
    userId: req.param('userId')
    date: req.param('date') || ""
  query.userId = req.user.id if query.userId == "me"
  db.Activity.findAll
    where: query
    attributes: [
      "url"
      [ db.sequelize.fn("max", db.sequelize.col("id")), "id" ]
      [ db.sequelize.fn("sum", db.sequelize.col("duration")), "totalDuration" ]
    ]
    group: [ "url" ]
  .then (summaries) ->
    ids = summaries.map (s) -> s.values.id
    db.Activity.findAll
      where:
        id: ids
      include: [ db.Site ]
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
        summary.totalDuration = Number(summary.totalDuration)
        delete summary.id
        summary
  .then (summaries) ->
    res.send summaries
  .catch error

###
# Create new activity
###
app.post "/api/activity", (req, res, error) ->
  activity = req.body
  activity.userId = req.user.id
  db.Activity.create activity
    .then (activity) ->
      console.log activity.values
      res.send(activity.values)
    .catch error

###
# Increment duration of existing activity
###
app.post "/api/activity/:activityId/duration", (req, res, error) ->
  activityId = req.param('activityId')
  inc = req.body.inc
  db.Activity.find activityId
    .then (activity) ->
      throw new Error("NOT_FOUND") unless activity
      throw new Error("ACCESS_NOT_ALLOWED") if activity.userId != req.user.id
      activity.increment "duration", inc
    .then (activity) ->
      res.send activity.values
    .catch error


