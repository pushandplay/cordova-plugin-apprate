module.exports = (grunt) ->
  config =
    app:
      name: 'AppRateDemoProject'
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
        name: config.app.path
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
      run_ios:
        options:
          command: 'run'
          platforms: ['ios']
          args: ['--debug']


  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-codo'
  grunt.loadNpmTasks 'grunt-cordovacli'

  grunt.registerTask 'default', ['coffee:compile']
  grunt.registerTask 'release', ['default', 'codo:docs']
  grunt.registerTask 'app:create', ['cordovacli:create', 'cordovacli:plugin', 'cordovacli:prepare']
  grunt.registerTask 'app:prepare', ['cordovacli:prepare']
  grunt.registerTask 'app:run_ios', ['default', 'cordovacli:run_ios']