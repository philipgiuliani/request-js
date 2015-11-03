class @Request
  Helpers.includeInto(this)

  _DEFAULTS =
    url: null
    method: "GET"
    async: true
    data: null
    form: null
    reviver: null

  METHODS = [
    "GET"
    "POST"
    "PUT"
    "DELETE"
  ]

  @interceptor = null

  @_addRequestMethod = (method) ->
    @[method] = (options={}) ->
      options.method = method
      new Request(options)

  @_addRequestMethod(method) for method in METHODS

  constructor: (options={}) ->
    @response = null
    @canceled = false

    @_emitter = new Emitter

    if !options.cors? || (options.cors && "withCredentials" in new XMLHttpRequest())
      @xhr = new XMLHttpRequest
    else
      @xhr = new XDomainRequest

    events = ["before", "success", "error", "complete", "progress"]
    for event in events
      if typeof options[event] is "function"
        @_emitter.on event, options[event]
        delete options[event]

    @merge this, _DEFAULTS

    if options.form?
      @url = options.form.action
      @method = options.form.method
      @data = new FormData(options.form)

    @merge this, options

  send: ->
    @xhr.addEventListener "progress", @_progressChange.bind(this)
    @xhr.addEventListener "readystatechange", @_stateChange.bind(this)

    @xhr.open(@method, @url, @async, @username, @password)
    @_setRequestHeaders()

    @_emitter.emit "before", @xhr
    @xhr.send @_requestData()

  abort: ->
    @canceled = true
    @xhr.abort()

  on: -> @_emitter.on.apply @_emitter, arguments
  off: -> @_emitter.off.apply @_emitter, arguments
  addEventListener: -> @_emitter.on.apply @_emitter, arguments
  removeEventListener: -> @_emitter.off.apply @_emitter, arguments

  _setRequestHeaders: ->
    @xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest")

    if @_dataIsObject()
      @xhr.setRequestHeader "Content-Type", "application/json;charset=UTF-8"

  _progressChange: (args...) ->
    @_emitter.emit "progress", args...

  _stateChange: ->
    return unless @xhr.readyState is XMLHttpRequest.DONE

    @response = new Response @xhr, reviver: @reviver

    if !Request.interceptor || Request.interceptor(@response)
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
