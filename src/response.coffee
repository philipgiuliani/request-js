class Response
  constructor: (@xhr) ->
    @status = @xhr.status
    @data = @_parseResponse()

  _parseResponse: ->
    try
      JSON.parse(@xhr.responseText)
    catch
      @xhr.responseText
