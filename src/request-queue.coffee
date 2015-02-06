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
    @jobs.sort @_sortJobs

    @_emitter.emit "enqueue", job

    job

  on: (args...) -> @_emitter.on args...
  off: (args...) -> @_emitter.off args...

  _dequeue: ->
    @jobs.shift()

  _sortJobs: (jobA, jobB) ->
    jobB.priority - jobA.priority
