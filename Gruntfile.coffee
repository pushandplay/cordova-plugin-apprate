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


  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-codo'

  grunt.registerTask 'default', ['coffee:compile', 'codo:docs']