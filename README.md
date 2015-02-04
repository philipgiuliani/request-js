# Request JS [![Build Status](https://travis-ci.org/philipgiuliani/request-js.svg?branch=master)](https://travis-ci.org/philipgiuliani/request-js)

Javascript XHR wrapper around XMLHttpRequest with integrated queueing support.

## Usage
### Making a Request
Coffeescript:
```coffeescript
request = new Request
  url: "/api/v1/users.json"

request.send()
```

Javascript:

```javascript
request = new Request({
  url: "/api/v1/users.json"
})
request.send()
```

### Handling the Response
You can attach serval events by using `on` or `addEventListener` to the request to handle the response. The events must be attached before calling `.send()`
Possible events are:

| Event name | Parameters        | When
|------------|-------------------|---------------------------------
| before     | xhr               | Before the request gets send, but after calling `xhr.open`. If you want to add additional headers, you can modify the `xhr` instance here.
| success    | data, xhr, status | If the request was success
| error      | xhr, status       | If the server returned an error
| complete   | xhr, status       | At the end of the request

If the `responseText` was able to be parsed with `JSON.parse`, an `Object` will be returned.

#### Example:
Coffeescript:
```coffeescript
request.on "success", (data, xhr, status) ->
  alert("Request status was: #{status}")
```

Javascript:
```javascript
request.on("success", function(data, xhr, status) {
  alert("Request status was: " + status);
});
```
