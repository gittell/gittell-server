request = require "supertest"
assert = require "power-assert"
_ = require "underscore"

app = require "../lib/app"
testUtil = require "./util"

###
# 
###
describe "user", ->

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
  it "should get logged in user", (done) ->

    agent.get("/api/user/me")
      .set "Authorization", "Bearer #{testUtil.accessToken}"
      .end (err, res) ->
        return done(err) if err
        assert.ok res.statusCode == 200
        user = res.body
        assert.ok _.isObject(user)
        assert.ok _.isNumber(user.id)
        assert.ok _.isString(user.username)
        assert.ok _.isString(user.displayName)
        done()

  ###
  #
  ###
  it "should list users", (done) ->

    agent.get("/api/user")
      .set "Authorization", "Bearer #{testUtil.accessToken}"
      .end (err, res) ->
        return done(err) if err
        assert.ok res.statusCode == 200
        users = res.body
        assert.ok _.isArray(users)
        for user in users
          assert.ok _.isObject(user)
          assert.ok _.isNumber(user.id)
          assert.ok _.isString(user.username)
          assert.ok _.isString(user.displayName)
        done()

