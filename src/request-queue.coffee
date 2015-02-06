class @RequestQueue
  Helpers.includeInto(this)

  @LOW: 0
  @NORMAL: 1
  @HIGH: 2
  @VERY_HIGH: 3

  constructor: (@workerCount=1) ->
    @jobs = []
    @runningJobs = []
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
    return if @runningJobs.length >= @workerCount

    while @_jobCanBeQueue()
      job = @_dequeue()
      @_startJob job

  _dequeue: ->
    return null if @jobs.length is 0

    sortedJobs = @jobs.slice(0).sort (jobA, jobB) ->
      jobB.priority - jobA.priority

    job = sortedJobs.shift()
    @_removeJob(job)

    job

  _startJob: (job) ->
    @_emitter.emit "start", job
    @runningJobs.push job
    job.run @_jobComplete.bind(this)

  _removeJob: (job) ->
    index = @jobs.indexOf(job)
    if index > -1
      @jobs.splice(index, 1)
      return true

    false

  _jobComplete: (job) ->
    @_emitter.emit "finish", job

    index = @runningJobs.indexOf(job)
    @runningJobs.splice(index, 1)

    @_checkQueue()

  _jobCanBeQueue: ->
    @jobs.length > 0 and @runningJobs.length < @workerCount
