class @RequestQueue
  constructor: ->
    @requests = []

  enqueue: (request, options={}) ->
    @requests.push request
