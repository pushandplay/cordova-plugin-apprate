module.exports = (grunt) ->
  config =
    app:
      name: 'AppRateDemoProject-test'
      path: '../'

  grunt.initConfig
    config: config
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
        path: '<%= config.app.path %><%= config.app.name %>/'
      create:
        options:
          command: ['create', 'platform']
          platforms: ['ios', 'android']
          id: 'org.pushandplay.cordova.<%= config.app.name %>'
          name: '<%= config.app.name %>'
          args: ['--link-to', 'www_app']
      plugin:
        options:
          command: 'plugin'
          action: 'add'
          plugins: ['../cordova-plugin-apprate']
      prepare:
        options:
          command: ['prepare']
          platforms: ['ios', 'android']


  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-codo'
  grunt.loadNpmTasks 'grunt-cordovacli'

  grunt.registerTask 'default', ['coffee:compile', 'app:prepare']
  grunt.registerTask 'release', ['default', 'codo:docs']
  grunt.registerTask 'app:create', ['cordovacli:create', 'cordovacli:plugin', 'cordovacli:prepare']
  grunt.registerTask 'app:prepare', ['cordovacli:prepare']