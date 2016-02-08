# CHANGELOG

## HEAD (Unreleased)
*(no changes)*

## 1.1.0 (08.02.2016)
* Added `request.abort()`.
* Added `form` option, which will set the action, method and data automatically.
* Added `X-Requested-With` header to get it working with rails `request.xhr?` method.
* Added `response.rawData` to access the `xhr.responseText`.

## 1.0.0 (07.04.2015)
* Added `response.success`.
* Changed the queue to enqueue jobs instead of requests.
* Added request class methods which will initialize the request and set the method. The current available methods are: `GET`, `PUT`, `POST`, `DELETE`.
* Added XDomainRequest support for IE CORS Requests.

## 0.0.1 (06.02.2015)
* First release
