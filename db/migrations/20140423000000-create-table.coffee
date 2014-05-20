module.exports = 
  up: (migration, DataTypes, done) ->
    # add altering commands here, calling 'done' when finished
    migration.showAllTables()
      .then (results) ->
        console.log results
        done()
      .catch (err) ->
        done(err)

  down: (migration, DataTypes, done) ->
    # add reverting commands here, calling 'done' when finished
    done()
