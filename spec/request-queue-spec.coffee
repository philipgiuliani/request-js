describe "RequestQueue", ->
  request = queue = null

  beforeEach ->
    queue = new RequestQueue

    request = new Request
      url: "/api/v1/users.json"

  describe "::add(request, options={})", ->
    it "adds a request to the queue", ->
      queue.add(request)

      expect(queue.queue.length).toEqual 1
