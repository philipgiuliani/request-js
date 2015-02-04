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

      expect(request._emitter._callbacks["success"].length).toBe 1
      expect(request._emitter._callbacks["success"][0]).toBe successCallback

    it "removes the events from the options", ->
      successCallback = -> true
      request = new Request
        success: successCallback

      expect(request["success"]).toBeUndefined()

    it "initializes a new XHR request", ->
      expect(request.xhr).toEqual jasmine.any(XMLHttpRequest)

  # describe "Class methods to set the method nicer", ->
  #   describe ".POST()", ->
  #     request = null
  #
  #     beforeEach ->
  #       request = new Request.POST
  #
  #     it "returns a new instance of `Request`", ->
  #       expect(request).toEqual jasmine.any(Request)
  #
  #     it "sets the method to `POST`", ->
  #       expect(request.method).toEqual "POST"

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

  describe "::send()", ->
    beforeEach ->
      jasmine.Ajax.install()

    afterEach ->
      jasmine.Ajax.uninstall()

    it "emits the `before` event with xhr as argument", ->
      jasmine.Ajax.stubRequest("/api/v1/users.json").andReturn(status: 200)

      beforeCallback = jasmine.createSpy("before")

      request = new Request
        url: "/api/v1/users.json"
        before: beforeCallback
      request.send()

      expect(beforeCallback).toHaveBeenCalled()

    it "responds with a JSON object if the response is JSON", ->
      jasmine.Ajax.stubRequest("/api/v1/users.json").andReturn
        status: 200
        responseText: JSON.stringify(user: { id: 1, firstName: "Philip" })


      completeCallback = jasmine.createSpy("complete")

      request = new Request
        url: "/api/v1/users.json"
        complete: completeCallback

      request.send()

      expect(request.response()).toEqual jasmine.any(Object)

    it "response with the Text if the response isn't parseable as JSON", ->
      jasmine.Ajax.stubRequest("/api/v1/users.json").andReturn
        status: 200
        responseText: "<errors>Amazing</errors>"

      completeCallback = jasmine.createSpy("complete")

      request = new Request
        url: "/api/v1/users.json"
        complete: completeCallback

      request.send()

      expect(request.response()).toEqual jasmine.any(String)
