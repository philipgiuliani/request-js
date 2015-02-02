class @Request extends Module
  @include Emitter

  constructor: (options = {}) ->
    @xhr = new XMLHttpRequest

    @url = options.url
    @method = options.method || "GET"
    @format = options.format || "json"
    @async = options.async || true
    @data = options.data || null

  send: ->
