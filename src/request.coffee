class @Request extends Module
  @include Emitter

  constructor: (options = {}) ->
    @xhr = new XMLHttpRequest

    @url = options.url
    @method = options.method || "GET"
    @format = options.format || "json"
    @async = options.async || true
    @data = options.data || null

    events = ["before", "success", "error", "complete"]
    for event in events
      if typeof options[event] is "function"
        @on event, options[event]

  send: ->
