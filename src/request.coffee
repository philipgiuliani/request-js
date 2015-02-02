class @Request
  constructor: (options = {}) ->
    @url = options.url
    @method = options.method || "GET"

  send: ->
