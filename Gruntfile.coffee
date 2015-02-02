module.exports = ->
  @initConfig
    pkg: @file.readJSON "package.json"

    meta:
      file: "request"
      package: "."
      temp:  "temp"

    resources:
      src: ["src/request.coffee"]
      spec: ["spec/*.coffee"]

    coffee:
      src:
        files:
          "<%= meta.temp %>/<%= meta.file %>.js": "<%= resources.src %>"
          "<%= meta.temp %>/spec.js": "<%= resources.spec %>"

    jasmine:
      pivotal:
        src: "<%= meta.temp %>/<%= meta.file %>.js"
        options:
          specs: "<%= meta.temp %>/spec.js"

    @loadNpmTasks 'grunt-contrib-coffee'
    @loadNpmTasks 'grunt-contrib-jasmine'

    @registerTask "default", ["coffee"]
    @registerTask "spec", ["coffee", "jasmine"]
