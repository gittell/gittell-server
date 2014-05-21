request = require "supertest"
assert = require "power-assert"
_ = require "underscore"

app = require "../lib/app"
testUtil = require "./util"

###
# 
###
describe "activity", ->

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
  it "should get activity summary of the logged in user", (done) ->

    agent.get("/api/user/me/activity/summary?date=20140521")
      .set "Authorization", "Bearer #{testUtil.accessToken}"
      .end (err, res) ->
        return done(err) if err
        assert.ok res.statusCode == 200
        activities = res.body
        assert.ok _.isArray(activities)
        for activity in activities
          assert.ok _.isObject(activity)
          assert.ok _.isString(activity.url)
          assert.ok _.isNumber(activity.totalDuration)
        done()

  activity = null

  ###
  #
  ###
  it "should post new activity", (done) ->

    agent.post("/api/activity")
      .set "Authorization", "Bearer #{testUtil.accessToken}"
      .send
        url: 'https://github.com/gittell/gittell-server'
        title: 'gittell/gittell-client'
        siteId: 1
        date: '20140521'
        duration: 16363
        projectUrl: "https://github.com/gittell/gittell-client"
        projectTitle: "gittell/gittell-client"
        since: '1400672101482'
      .end (err, res) ->
        return done(err) if err
        assert.ok res.statusCode == 200
        activity = res.body
        assert.ok _.isObject(activity)
        assert.ok _.isNumber(activity.id)
        assert.ok _.isString(activity.url)
        assert.ok _.isNumber(activity.duration)
        assert.ok _.isString(activity.since)
        assert.ok _.isString(activity.createdAt)
        assert.ok _.isString(activity.updatedAt)
        done()

  ###
  #
  ###
  it "should increment duration of existing activity", (done) ->

    agent.post("/api/activity/#{activity.id}/duration")
      .set "Authorization", "Bearer #{testUtil.accessToken}"
      .send
        inc: 4000
      .end (err, res) ->
        return done(err) if err
        assert.ok res.statusCode == 200
        newActivity = res.body
        assert.ok _.isObject(newActivity)
        assert.ok _.isNumber(newActivity.id)
        assert.ok activity.duration + 4000 == newActivity.duration
        assert.ok activity.updatedAt < newActivity.updatedAt
        done()


