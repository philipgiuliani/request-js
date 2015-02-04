class @Request extends Module
  @include Emitter
  @include Helpers

  DEFAULTS =
    url: null
    method: "GET"
    format: "json"
    async: true
    data: null

  constructor: (options = {}) ->
    @xhr = new XMLHttpRequest

    @merge this, DEFAULTS
    @merge this, options

    events = ["before", "success", "error", "complete"]
    for event in events
      if typeof options[event] is "function"
        @on event, options[event]

  send: ->
    @xhr.open(@method, @url, @async, @username, @password)

    @emit "before", @xhr

    @xhr.addEventListener "readystatechange", @_handleStateChange.bind(this)
    @xhr.send @_requestData()

  _handleStateChange: ->
    return unless @xhr.readyState is XMLHttpRequest.DONE

    if @xhr.status in [200..299]
      @_requestSuccess()
    else
      @_requestError()

    @emit "complete", @xhr, @xhr.status

  _requestSuccess: ->
    if @format is "json"
      response = JSON.parse(@xhr.responseText)
    else
      response = @xhr.responseText

    @emit "success", response, @xhr.status, @xhr

  _requestError: ->
    @emit "error", @xhr, @xhr.status

  _requestData: ->
    if @data && @data.constructor is Object
      return JSON.stringify(@data)

    @data
