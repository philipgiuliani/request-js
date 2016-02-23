class Response
  constructor: (@xhr, options={}) ->
    @status = @xhr.status
    @data = @_parseResponse(options.reviver)
    @success = @_wasSuccess()
    @rawData = @xhr.responseText

  _parseResponse: (reviver) ->
    try
      JSON.parse(@xhr.responseText, reviver)
    catch
      @xhr.responseText

  _wasSuccess: ->
    @status in [200..299]
