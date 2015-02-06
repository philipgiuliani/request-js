describe "Response", ->
  xhr = response = responseJSON = null

  beforeEach ->
    responseJSON =
      errors:
        key: "value"

    xhr =
      status: 200
      responseText: JSON.stringify(responseJSON)

  it "has the xhr object", ->
    response = new Response(xhr)
    expect(response.xhr).toBe xhr

  it "has the status of the request", ->
    response = new Response(xhr)
    expect(response.status).toEqual 200

  it "returns the data as JSON if it was able to be parsed", ->
    response = new Response(xhr)
    expect(response.data).toEqual responseJSON

  it "rreturns the data as text if it couldn't be parsed", ->
    responseXML = "<error>This is XML</error>"
    xhr.responseText = responseXML

    response = new Response(xhr)
    expect(response.data).toEqual responseXML
