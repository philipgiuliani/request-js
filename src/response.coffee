class Response
  constructor: (@xhr) ->
    @status = @xhr.status
    @data = @_parseResponse()
    @success = @_wasSuccess()

  _parseResponse: ->
    try
      JSON.parse(@xhr.responseText)
    catch
      @xhr.responseText

  _wasSuccess: ->
    @status in [200..299]
