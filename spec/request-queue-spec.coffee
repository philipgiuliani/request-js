describe "RequestQueue", ->
  request = queue = job = null

  beforeEach ->
    queue = new RequestQueue

    request = new Request
      url: "/api/v1/users.json"

    job = new RequestJob(request)

  describe "::enqueue(request, options={})", ->
    beforeEach ->
      spyOn queue, "_checkQueue"

    it "adds a job to the queue", ->
      queue.enqueue(job)

      expect(queue.jobs.length).toEqual 1

    it "returns a RequestJob", ->
      queuedJob = queue.enqueue(job)

      expect(job).toEqual jasmine.any(RequestJob)

    it "emits an event on adding a new job", ->
      callback = jasmine.createSpy("enqueue")
      queue.on "enqueue", callback

      queuedJob = queue.enqueue(job)

      expect(callback).toHaveBeenCalledWith(queuedJob)

  describe "::_dequeue()", ->
    beforeEach ->
      spyOn queue, "_checkQueue"

    it "gets the next job in the queue", ->
      queuedJob = queue.enqueue(job)
      expect(queue._dequeue()).toBe queuedJob

    it "should get the next job sorted by the highest priority and time", ->
      jobNormal = queue.enqueue(job)
      jobHigh1 = queue.enqueue(job, RequestQueue.HIGH)
      jobLow = queue.enqueue(job, RequestQueue.LOW)
      jobHigh2 = queue.enqueue(job, RequestQueue.HIGH)

      expect(queue._dequeue()).toBe jobHigh1
      expect(queue._dequeue()).toBe jobHigh2
      expect(queue._dequeue()).toBe jobNormal
      expect(queue._dequeue()).toBe jobLow

    it "removes the job from the queue", ->
      queue.enqueue(job)
      queue._dequeue()

      expect(queue.jobs.length).toBe 0

    it "returns null if no job is queued", ->
      result = queue._dequeue()

      expect(result).toBeNull()
