class @Request
  Helpers.includeInto(this)

  DEFAULTS =
    url: null
    method: "GET"
    format: "json"
    async: true
    data: null

  # @POST = (options={}) ->
  #   options.method = "POST"
  #   new Request(options)

  constructor: (options={}) ->
    @_emitter = new Emitter
    @xhr = new XMLHttpRequest

    events = ["before", "success", "error", "complete"]
    for event in events
      if typeof options[event] is "function"
        @_emitter.on event, options[event]
        delete options[event]

    @merge this, DEFAULTS
    @merge this, options

  send: ->
    @xhr.addEventListener "readystatechange", @_handleStateChange.bind(this)
    @xhr.open(@method, @url, @async, @username, @password)

    @_setRequestHeaders()

    @_emitter.emit "before", @xhr
    @xhr.send @_requestData()

  response: ->
    return false if @xhr.readyState isnt 4

    try
      JSON.parse(@xhr.responseText)
    catch
      @xhr.responseText

  on: (args...) -> @_emitter.on args...

  off: (args...) -> @_emitter.off args...

  _setRequestHeaders: ->
    if @_dataIsObject()
      @xhr.setRequestHeader "Content-Type", "application/json;charset=UTF-8"

  _handleStateChange: ->
    return unless @xhr.readyState is XMLHttpRequest.DONE

    if @xhr.status in [200..299]
      @_emitter.emit "success", @response(), @xhr.status, @xhr
    else
      @_emitter.emit "error", @xhr, @xhr.status

    @_emitter.emit "complete", @xhr, @xhr.status

  _dataIsObject: ->
    @data && @data.constructor is Object

  _requestData: ->
    if @_dataIsObject()
      return JSON.stringify(@data)

    @data
