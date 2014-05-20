
###
Module dependencies.
###
express = require "express"
http = require "http"
path = require "path"

app = module.exports = express()

# all environments
app.set "port", process.env.PORT or 3000
app.set "views", path.join(__dirname, "..", "views")
app.set "view engine", "ejs"
app.use express.logger("dev")
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use express.cookieParser()
app.use express.session(secret: 'raewrqwzrho', key: 'sid')
app.use express.bodyParser()
app.use app.router
app.use express.static(path.join(__dirname, "..", "public"))

# development only
# app.use express.errorHandler()  if "development" is app.get("env")

db = require "./models"
ctrl = require "./controllers"

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

