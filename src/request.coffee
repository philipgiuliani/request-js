class @Request
  Helpers.includeInto(this)

  _DEFAULTS =
    url: null
    method: "GET"
    async: true
    data: null

  METHODS = [
    "GET"
    "POST"
    "PUT"
    "DELETE"
  ]

  @_addRequestMethod = (method) ->
    @[method] = (options={}) ->
      options.method = method
      new Request(options)

  @_addRequestMethod(method) for method in METHODS

  constructor: (options={}) ->
    @response = null

    @_emitter = new Emitter
    @xhr = new XMLHttpRequest

    events = ["before", "success", "error", "complete", "progress"]
    for event in events
      if typeof options[event] is "function"
        @_emitter.on event, options[event]
        delete options[event]

    @merge this, _DEFAULTS
    @merge this, options

  send: ->
    @xhr.addEventListener "progress", @_progressChange.bind(this)
    @xhr.addEventListener "readystatechange", @_stateChange.bind(this)

    @xhr.open(@method, @url, @async, @username, @password)
    @_setRequestHeaders()

    @_emitter.emit "before", @xhr
    @xhr.send @_requestData()

  on: -> @_emitter.on.apply @_emitter, arguments
  off: -> @_emitter.off.apply @_emitter, arguments

  _setRequestHeaders: ->
    if @_dataIsObject()
      @xhr.setRequestHeader "Content-Type", "application/json;charset=UTF-8"

  _progressChange: (args...) ->
    @_emitter.emit "progress", args...

  _stateChange: ->
    return unless @xhr.readyState is XMLHttpRequest.DONE

    @response = new Response @xhr

    if @response.success
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
