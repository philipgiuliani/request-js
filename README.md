# Request JS [![Build Status](https://travis-ci.org/philipgiuliani/requester-js.svg?branch=master)](https://travis-ci.org/philipgiuliani/requester-js)

Request JS is a wrapper around `XMLHttpRequest` which simplifies its usage and makes it more readable.

## Options
```coffeescript
request = new Request
  url: "/api/v1/users.json" # URL of the request
  method: "POST" # Default is `GET`
  async: false # Default is `true`
  data: { firstName: "John" } # Data to submit, default is `null`

  before: (xhr) -> true
  success: (data, xhr, status) -> true
  error: (xhr, status) -> true
  complete: (xhr, status) -> true
```

For the callback description see [Handling the Response](#handling-the-response).

## Examples
### Making a Request
```coffeescript
request = new Request
  url: "/api/v1/users.json"
  method: "POST"
  data:
    firstName: "John"
    lastName: "Doe"

request.send()
```

### Handling the Response
You can attach serval events by using `on` or `addEventListener` to the request to handle the response. The events must be attached before calling `.send()`.

| Event name | Parameters        | When
|------------|-------------------|---------------------------------
| before     | xhr               | Before the request gets send, but after calling `xhr.open`. If you want to add additional headers, you can modify the `xhr` instance here.
| success    | data, xhr, status | If the request was success
| error      | xhr, status       | If the server returned an error
| complete   | xhr, status       | At the end of the request

If the `responseText` was able to be parsed with `JSON.parse`, an `Object` will be returned.

#### Example
```coffeescript
request.on "success", (data, xhr, status) ->
  alert("Request status was: #{status}")
```
