class @RequestQueue
  Helpers.includeInto(this)

  @LOW: 0
  @NORMAL: 1
  @HIGH: 2
  @VERY_HIGH: 3

  constructor: ->
    @jobs = []
    @currentJob = null
    @_emitter = new Emitter

  enqueue: (request, priority) ->
    job = new RequestQueueJob(request, priority)
    @jobs.push job

    @_emitter.emit "enqueue", job

    @_checkQueue()

    job

  on: (args...) -> @_emitter.on args...
  off: (args...) -> @_emitter.off args...

  _checkQueue: ->
    return if @currentJob

    @currentJob = @_dequeue()
    @_emitter.emit "start", @currentJob

    request = @currentJob.request
    request.on "complete", @_requestComplete.bind(this)
    request.send()

  _dequeue: ->
    return null if @jobs.length is 0

    sortedJobs = @jobs.slice(0).sort (jobA, jobB) ->
      jobB.priority - jobA.priority

    job = sortedJobs[0]

    jobIndex = @jobs.indexOf(job)
    @jobs.splice(jobIndex, 1)

    job

  _requestComplete: ->
    @_emitter.emit "finish", @currentJob

    @currentJob = null
    @_checkQueue()
