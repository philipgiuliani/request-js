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
    @xhr.open(@method, @url, @async)

    if @format is "json"
      @xhr.setRequestHeader "Content-Type", "application/json"

    @emit "before", @xhr

    @xhr.addEventListener "readystatechange", @_handleStateChange.bind(this)

    @xhr.send @_params()

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

    @emit "success", data, @xhr.status, xhr

  _requestError: ->
    @emit "error", @xhr, @xhr.status

  _params: ->
    return null unless @data
    JSON.stringify(@data)
