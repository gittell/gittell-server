fs = require "fs"

module.exports = (grunt) ->

  pkg = grunt.file.readJSON('package.json')
  if pkg.devDependencies
    Object.keys(pkg.devDependencies).filter (pkgname) ->
      grunt.loadNpmTasks(pkgname) if pkgname.indexOf('grunt-') == 0

  grunt.initConfig
    pkg: pkg

    target: 'develop'

    clientProjectRoot: '../gittell-client'

    libDir: './lib'

    viewsDir: './views'

    publicDir: './public'

    watch:
      server:
        files: [ "<%= libDir %>/**/*", "<%= viewsDir %>/**/*", "<%= publicDir %>/client/js/main.js" ]
        options:
          livereload: true
          interval: 5000
      client:
        files: [ "<%= clientProjectRoot %>/build/<%= target %>/**/*" ]
        tasks: [ 'copy:client' ]

    grunt:
      client:
        gruntfile: '<%= clientProjectRoot %>/Gruntfile.coffee'
        tasks: [ 'build:<%= target %>' ]
      clientWatch:
        gruntfile: '<%= clientProjectRoot %>/Gruntfile.coffee'
        tasks: [ 'watch' ]

    copy:
      client:
        files: [
          expand: true
          cwd: '<%= clientProjectRoot %>/build/<%= target %>'
          src: [ '**/*' ],
          dest: '<%= publicDir %>/client'
        ]

    concurrent:
      watch:
        tasks: [ 'grunt:clientWatch', 'watch' ]
      options:
        logConcurrentOutput: true

    clean:
      client:
        src: [ "<%= publicDir %>/client" ]

  grunt.registerTask 'server:local', [ 'build:local', 'concurrent:watch' ]
  grunt.registerTask 'server:develop', [ 'build:develop', 'concurrent:watch' ]
  grunt.registerTask 'server:staging', [ 'build:staging', 'concurrent:watch' ]
  grunt.registerTask 'server:production', [ 'build:production', 'concurrent:watch' ]
  grunt.registerTask 'target:local', -> grunt.config('target', 'local')
  grunt.registerTask 'target:develop', -> grunt.config('target', 'develop')
  grunt.registerTask 'target:staging', -> grunt.config('target', 'staging')
  grunt.registerTask 'target:production', -> grunt.config('target', 'production')
  grunt.registerTask 'build:local', [ 'clean', 'target:local', 'grunt:client', 'copy:client' ]
  grunt.registerTask 'build:develop', [ 'clean', 'target:develop', 'grunt:client', 'copy:client' ]
  grunt.registerTask 'build:staging', [ 'clean', 'target:staging', 'grunt:client', 'copy:client' ]
  grunt.registerTask 'build:production', [ 'clean', 'target:production', 'grunt', 'copy' ]
  grunt.registerTask 'default', [ 'build:local' ]

