class @RequestQueue
  constructor: ->
    @jobs = []

  enqueue: (request, options={}) ->
    @jobs.push request
