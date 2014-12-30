module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      options:
        bare: true
      compile:
        expand: true
        flatten: true
        cwd: './'
        src: ['www_src/*.coffee']
        dest: 'www'
        ext: '.js'
    codo:
      options:
        output: "./docs"
      docs:
        src: ["www_src"]
    cordovacli:
      options:
        path: 'AppRateDemoProject'
      create:
        options:
          command: ['create', 'platform', 'plugin']
          platforms: ['ios', 'android']
          plugins: []
          id: 'org.pushandplay.cordova.AppRateDemoProject'
          name: 'AppRateDemoProject'
          args: ['--link-to', 'www_app']
      prepare:
        options:
          command: ['prepare']
          platforms: ['ios', 'android']


  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-codo'
  grunt.loadNpmTasks 'grunt-cordovacli'

  grunt.registerTask 'default', ['coffee:compile', 'cordovacli:prepare']
  grunt.registerTask 'release', ['default', 'codo:docs']
  grunt.registerTask 'app', ['cordovacli:prepare']