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
      successCallback = -> true

      request = new Request
        success: successCallback

      expect(request._callbacks["success"].length).toBe 1
      expect(request._callbacks["success"][0]).toBe successCallback

    it "initializes a new XHR request", ->
      expect(request.xhr).toEqual jasmine.any(XMLHttpRequest)

  describe "::_requestData()", ->
    it "returns null when no data is given", ->
      request.data = null
      expect(request._requestData()).toBeNull()

    it "returns the data if a `FormData` is given", ->
      formData = new FormData
      request.data = formData

      expect(request._requestData()).toBe formData

    it "returns a stringified json if a `Object` is given", ->
      data = { name: "philip" }
      request.data = data

      expect(request._requestData()).toEqual JSON.stringify(data)
