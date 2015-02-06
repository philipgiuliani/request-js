module.exports = ->
  @initConfig
    pkg: @file.readJSON "package.json"

    meta:
      file: "request"
      package: "."
      temp:  "temp"
      build: "build"
      banner: """
      /**
       * <%= pkg.name %> - version <%= pkg.version %>
       * <%= pkg.description %>
       * Copyright <%= grunt.template.today("yyyy") %> by <%= pkg.author.name %> - <%= pkg.author.email %>
       */
      """


    resources:
      src: [
        "src/emitter.coffee"
        "src/helpers.coffee"
        "src/request.coffee"
        "src/response.coffee"
        "src/request-queue.coffee"
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

    uglify:
      options:
        compress:
          drop_console: true
      my_target:
        files:
          "<%= meta.build %>/<%= meta.file %>.min.js": "<%= meta.build %>/<%= meta.file %>.js"

    usebanner:
      options:
        position: "top"
        banner: "<%= meta.banner %>"
        linebreak:true
      files:
        src: [
          "<%= meta.build %>/<%= meta.file %>.js"
          "<%= meta.build %>/<%= meta.file %>.min.js"
        ]

    @loadNpmTasks 'grunt-contrib-coffee'
    @loadNpmTasks 'grunt-contrib-jasmine'
    @loadNpmTasks 'grunt-contrib-uglify'
    @loadNpmTasks 'grunt-banner'

    @registerTask "default", ["coffee:build", "uglify", "usebanner"]
    @registerTask "test", ["coffee:specs", "jasmine"]
