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
