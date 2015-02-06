class RequestQueueJob
  constructor: (request, priority=RequestQueue.NORMAL) ->
    @request = request
    @priority = priority
    @oncomplete = null

  run: (complete) ->
    @request.on "complete", complete(this)
    @request.send()
