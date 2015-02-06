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
