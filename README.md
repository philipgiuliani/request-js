# Request JS [![Build Status](https://travis-ci.org/philipgiuliani/request-js.svg?branch=master)](https://travis-ci.org/philipgiuliani/request-js)

Request JS is a wrapper around `XMLHttpRequest` which simplifies its usage and makes it more readable.

Get the latest version from [Github Releases](https://github.com/philipgiuliani/request-js/releases).

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

## Contributing
Ensure that you have installed [Node.js](http://www.nodejs.org) and [npm](http://www.npmjs.org/)

Test that Grunt's CLI is installed by running `grunt --version`. If the command isn't found, run `npm install -g grunt-cli`. For more information about installing Grunt, see the [getting started guide](http://gruntjs.com/getting-started).

1. Fork and clone the repository.
2. Run `npm install` to install the dependencies.
3. Run `grunt` to grunt this project.

### Tests
Make sure that all tests are passing before creating a Pull request. You can run the tests with `grunt test`.

The tests are located in `spec/` and written with [Jasmine](http://jasmine.github.io/).
