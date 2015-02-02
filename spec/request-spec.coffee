describe "Request", ->
  request = null

  beforeEach ->
    request = new Request

  describe "constructor", ->
    it "sets the method to GET by default", ->
      expect(request.method).toEqual "GET"

    it "assigns the options", ->
      request = new Request
        method: "POST"
        url: "/api/v1/example.json"

      expect(request.method).toBe "POST"
      expect(request.url).toBe "/api/v1/example.json"

    it "attaches the given events", ->
      successCallback = ->
        console.log "It worked"

      request = new Request
        success: successCallback

      expect(request._callbacks["success"].length).toBe 1
      expect(request._callbacks["success"][0]).toBe successCallback

    it "initializes a new XHR request", ->
      expect(request.xhr).toEqual jasmine.any(XMLHttpRequest)
