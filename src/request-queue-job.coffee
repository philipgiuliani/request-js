class RequestQueueJob
  constructor: (request, priority=RequestQueue.NORMAL) ->
    @request = request
    @priority = priority

  run: (complete) ->
    @request.on "complete", complete(this)
    @request.async = true
    @request.send()
