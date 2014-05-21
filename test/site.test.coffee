request = require "supertest"
assert = require "power-assert"
_ = require "underscore"

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
        assert.ok res.statusCode == 200
        assert.ok _.isArray(res.body) && res.body.length > 0
        for site in res.body
          assert.ok _.isNumber(site.id)
          assert.ok _.isString(site.url)
          assert.ok _.isString(site.title)
          assert.ok _.isString(site.iconUrl)
          assert.ok _.isObject(site.manifest)
          assert.ok _.isObject(site.manifest.condition)
        done()

