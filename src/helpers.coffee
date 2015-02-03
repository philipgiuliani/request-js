Helpers =
  merge: (object, properties) ->
    for key, val of properties
      object[key] = val
    object
