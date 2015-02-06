class RequestQueueJob
  constructor: (request, priority=RequestQueue.NORMAL) ->
    @request = request
    @priority = priority
