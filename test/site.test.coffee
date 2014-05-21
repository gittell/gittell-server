request = require "supertest"
assert = require "power-assert"

app = require "../lib/app"
testUtil = require "./util"

###
# 
###
describe "site", ->

  @timeout 100000

  ###
  #
  ###
  before (done) ->
    testUtil.setup().then ->
      testUtil.loginAs(1)
    .then () ->
      done()
    .catch (err) ->
      done(err)

  ###
  #
  ###
  after (done) ->
    testUtil.teardown().then ->
      done()
    .catch (err) ->
      done(err)

  agent = request(app)

  ###
  #
  ###
  it "should list site registered", (done) ->

    agent.get("/api/site")
      .set "Authorization", "Bearer #{testUtil.accessToken}"
      .end (err, res) ->
        return done(err) if err
        assert.ok res.status == 210
        done()

