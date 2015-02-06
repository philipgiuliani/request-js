class @Request
  Helpers.includeInto(this)

  DEFAULTS =
    url: null
    method: "GET"
    async: true
    data: null

  # @POST = (options={}) ->
  #   options.method = "POST"
  #   new Request(options)

  constructor: (options={}) ->
    @response = null

    @_emitter = new Emitter
    @xhr = new XMLHttpRequest

    events = ["before", "success", "error", "complete", "progress"]
    for event in events
      if typeof options[event] is "function"
        @_emitter.on event, options[event]
        delete options[event]

    @merge this, DEFAULTS
    @merge this, options

  send: ->
    @xhr.addEventListener "progress", @_progressChange.bind(this)
    @xhr.addEventListener "readystatechange", @_stateChange.bind(this)

    @xhr.open(@method, @url, @async, @username, @password)
    @_setRequestHeaders()

    @_emitter.emit "before", @xhr
    @xhr.send @_requestData()

  on: (args...) -> @_emitter.on args...
  off: (args...) -> @_emitter.off args...

  _setRequestHeaders: ->
    if @_dataIsObject()
      @xhr.setRequestHeader "Content-Type", "application/json;charset=UTF-8"

  _progressChange: (args...) ->
    @_emitter.emit "progress", args...

  _stateChange: ->
    return unless @xhr.readyState is XMLHttpRequest.DONE

    @response = new Response(@xhr)

    if @xhr.status in [200..299]
      @_emitter.emit "success", @response
    else
      @_emitter.emit "error", @response

    @_emitter.emit "complete", @response

  _dataIsObject: ->
    @data && @data.constructor is Object

  _requestData: ->
    if @_dataIsObject()
      return JSON.stringify(@data)

    @data
