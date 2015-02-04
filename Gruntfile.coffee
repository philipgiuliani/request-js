module.exports = ->
  @initConfig
    pkg: @file.readJSON "package.json"

    meta:
      file: "request"
      package: "."
      temp:  "temp"
      build: "build"

    resources:
      src: [
        "src/module.coffee"
        "src/emitter.coffee"
        "src/helpers.coffee"
        "src/request.coffee"
      ]
      spec: ["spec/*.coffee"]

    coffee:
      specs:
        files:
          "<%= meta.temp %>/<%= meta.file %>.js": "<%= resources.src %>"
          "<%= meta.temp %>/spec.js": "<%= resources.spec %>"
        options:
          bare: true

      build:
        files:
          "<%= meta.build %>/<%= meta.file %>.js": "<%= resources.src %>"
        options:
          join: true

    jasmine:
      pivotal:
        src: "<%= meta.temp %>/<%= meta.file %>.js"
        options:
          specs: "<%= meta.temp %>/spec.js"
          vendor: "vendor/*.js"

    @loadNpmTasks 'grunt-contrib-coffee'
    @loadNpmTasks 'grunt-contrib-jasmine'

    @registerTask "default", ["coffee:build"]
    @registerTask "spec", ["coffee:specs", "jasmine"]
