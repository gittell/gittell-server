app = require "../app"
db = require "../models"

 
###
# Show activity summary of user
###
app.get "/api/user/:userId/activity/summary", (req, res, error) ->
  condition =
    userId: req.param('userId')
    date: req.param('date') || ""
  condition.userId = req.user.id if condition.userId == "me"
  db.Activity.groupBy("url", condition)
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
      activity.increment "duration", { by: inc }
    .then (activity) ->
      res.send activity.values
    .catch error


