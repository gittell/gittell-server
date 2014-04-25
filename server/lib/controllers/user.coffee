app = require "../app"
db = require "../models"

###
# List users
###
app.get "/api/user", (req, res) ->
  db.User.all()
    .then (users) ->
      res.send(users)

###
# Show Auth User Profile
###
app.get "/api/user/me", (req, res) ->
  res.send req.user

