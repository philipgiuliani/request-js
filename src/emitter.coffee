class Emitter
  constructor: ->
    @_callbacks = {}

  on: (event, fn) ->
    @_callbacks[event] or= []
    @_callbacks[event].push fn
    this

  off: (event, fn) ->
    listeners = @_callbacks[event]
    return this unless listeners

    # remove the listener
    if 1 is arguments.length
      delete @_callbacks[event]
      return this

    # remove specific handler
    i = listeners.indexOf(fn._off or fn)
    listeners.splice i, 1 if ~i
    this

  emit: (event, args...) ->
    listeners = @_callbacks[event]
    if listeners
      for listener in listeners.slice 0
        listener.apply(this, args)
    this

Emitter.addEventListener = Emitter.on
Emitter.removeEventListener = Emitter.off
