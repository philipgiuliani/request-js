describe "RequestQueue", ->
  request = queue = null

  beforeEach ->
    queue = new RequestQueue

    request = new Request
      url: "/api/v1/users.json"

  describe "::enqueue(request, options={})", ->
    beforeEach ->
      spyOn queue, "_checkQueue"

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

  fdescribe "::_dequeue()", ->
    beforeEach ->
      spyOn queue, "_checkQueue"

    it "gets the next job in the queue", ->
      job = queue.enqueue(request)
      expect(queue._dequeue()).toBe job

    it "should get the next job sorted by the highest priority and time", ->
      jobNormal = queue.enqueue(request)
      jobHigh1 = queue.enqueue(request, RequestQueue.HIGH)
      jobLow = queue.enqueue(request, RequestQueue.LOW)
      jobHigh3 = queue.enqueue(request, RequestQueue.HIGH)

      expect(queue._dequeue()).toBe jobHigh1

    it "removes the job from the queue", ->
      queue.enqueue(request)
      queue._dequeue()

      expect(queue.jobs.length).toBe 0
