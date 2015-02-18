class @RequestJob
  constructor: (@request, @priority=RequestQueue.NORMAL) ->

  run: (complete) ->
    @request.on "complete", complete.bind(this)
    @request.async = true
    @request.send()
