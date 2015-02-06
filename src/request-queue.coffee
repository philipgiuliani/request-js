class @RequestQueue
  Helpers.includeInto(this)

  @LOW: 0
  @NORMAL: 1
  @HIGH: 2
  @VERY_HIGH: 3

  constructor: ->
    @jobs = []
    @_emitter = new Emitter

  enqueue: (request, priority=RequestQueue.NORMAL) ->
    job = new RequestQueueJob(request, priority)
    @jobs.push job
    @_emitter.emit "enqueue", job
    job


class RequestQueueJob
  constructor: (request, priority=RequestQueue.NORMAL) ->
    @request = request
    @priority = priority
