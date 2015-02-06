describe "RequestQueue", ->
  request = queue = null

  beforeEach ->
    queue = new RequestQueue

    request = new Request
      url: "/api/v1/users.json"

  describe "::enqueue(request, options={})", ->
    it "adds a request to the queue", ->
      queue.enqueue(request)

      expect(queue.jobs.length).toEqual 1

    it "returns a RequestQueueJob", ->
      job = queue.enqueue(request)

      expect(job).toEqual jasmine.any(RequestQueueJob)

    it "emits an event on adding a new job", ->
      callback = jasmine.createSpy("enqueue")
      queue.on "enqueue", callback

      job = queue.enqueue(request)

      expect(callback).toHaveBeenCalledWith(job)

    it "sorts the jobs by the priority after adding one", ->
      jobNormal = queue.enqueue(request, RequestQueue.NORMAL)
      jobLow = queue.enqueue(request, RequestQueue.LOW)
      jobHigh = queue.enqueue(request, RequestQueue.HIGH)

      expect(queue.jobs).toEqual [jobHigh, jobNormal, jobLow]

  describe "::_dequeue()", ->
    it "returns the next job in the queue", ->
      job = queue.enqueue(request)
      expect(queue._dequeue()).toBe job

    it "removes the job from the queue", ->
      queue.enqueue(request)
      queue._dequeue()

      expect(queue.jobs.length).toBe 0
