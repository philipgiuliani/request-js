class RequestQueue
  constructor: ->
    @queue = []

  add: (request, options={}) ->
    @queue.push request
