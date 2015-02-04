Helpers =
  merge: (object, properties) ->
    for key, val of properties
      object[key] = val
    object

  # Include the Helpers
  includeInto: (scope) ->
    moduleKeywords = ['extended', 'included', 'includeInto']

    for key, value of this when key not in moduleKeywords
      scope::[key] = value

    scope.included?.apply(this)
    this
