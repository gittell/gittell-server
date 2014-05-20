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

    publicDir: './public'

    grunt:
      client:
        gruntfile: '<%= clientProjectRoot %>/Gruntfile.js'
        tasks: [ 'build:<%= target %>' ]

    copy:
      client:
        files: [
          expand: true
          cwd: '<%= clientProjectRoot %>/build/<%= target %>'
          src: [ '**/*' ],
          dest: '<%= publicDir %>/client'
        ]

    clean:
      client:
        src: [ "<%= publicDir %>/client" ]

  grunt.registerTask 'target:develop', -> grunt.config('target', 'develop')
  grunt.registerTask 'target:staging', -> grunt.config('target', 'staging')
  grunt.registerTask 'target:production', -> grunt.config('target', 'production')
  grunt.registerTask 'build:develop', [ 'clean', 'target:develop', 'grunt', 'copy' ]
  grunt.registerTask 'build:staging', [ 'clean', 'target:staging', 'grunt', 'copy' ]
  grunt.registerTask 'build:production', [ 'clean', 'target:production', 'grunt', 'copy' ]
  grunt.registerTask 'default', [ 'build:develop' ]

