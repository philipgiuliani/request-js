/**
 * request-js - version 1.0.0
 * Request JS is a wrapper around XMLHttpRequest which simplifies its usage and makes it more readable.
 * Copyright 2015 by Philip Giuliani - info@philipg.net
 */
(function() {
  var Emitter, Helpers, Response,
    __slice = [].slice,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  Emitter = (function() {
    function Emitter() {
      this._callbacks = {};
    }

    Emitter.prototype.on = function(event, fn) {
      var _base;
      (_base = this._callbacks)[event] || (_base[event] = []);
      this._callbacks[event].push(fn);
      return this;
    };

    Emitter.prototype.off = function(event, fn) {
      var i, listeners;
      listeners = this._callbacks[event];
      if (!listeners) {
        return this;
      }
      if (1 === arguments.length) {
        delete this._callbacks[event];
        return this;
      }
      i = listeners.indexOf(fn._off || fn);
      if (~i) {
        listeners.splice(i, 1);
      }
      return this;
    };

    Emitter.prototype.emit = function() {
      var args, event, listener, listeners, _i, _len, _ref;
      event = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      listeners = this._callbacks[event];
      if (listeners) {
        _ref = listeners.slice(0);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          listener = _ref[_i];
          listener.apply(this, args);
        }
      }
      return this;
    };

    return Emitter;

  })();

  Helpers = {
    merge: function(object, properties) {
      var key, val;
      for (key in properties) {
        val = properties[key];
        object[key] = val;
      }
      return object;
    },
    includeInto: function(scope) {
      var key, moduleKeywords, value, _ref;
      moduleKeywords = ['extended', 'included', 'includeInto'];
      for (key in this) {
        value = this[key];
        if (__indexOf.call(moduleKeywords, key) < 0) {
          scope.prototype[key] = value;
        }
      }
      if ((_ref = scope.included) != null) {
        _ref.apply(this);
      }
      return this;
    }
  };

  this.Request = (function() {
    var METHODS, method, _DEFAULTS, _i, _len;

    Helpers.includeInto(Request);

    _DEFAULTS = {
      url: null,
      method: "GET",
      async: true,
      data: null,
      form: null
    };

    METHODS = ["GET", "POST", "PUT", "DELETE"];

    Request.interceptor = null;

    Request._addRequestMethod = function(method) {
      return this[method] = function(options) {
        if (options == null) {
          options = {};
        }
        options.method = method;
        return new Request(options);
      };
    };

    for (_i = 0, _len = METHODS.length; _i < _len; _i++) {
      method = METHODS[_i];
      Request._addRequestMethod(method);
    }

    function Request(options) {
      var event, events, _j, _len1;
      if (options == null) {
        options = {};
      }
      this.response = null;
      this._emitter = new Emitter;
      if ((options.cors == null) || (options.cors && __indexOf.call(new XMLHttpRequest(), "withCredentials") >= 0)) {
        this.xhr = new XMLHttpRequest;
      } else {
        this.xhr = new XDomainRequest;
      }
      events = ["before", "success", "error", "complete", "progress"];
      for (_j = 0, _len1 = events.length; _j < _len1; _j++) {
        event = events[_j];
        if (typeof options[event] === "function") {
          this._emitter.on(event, options[event]);
          delete options[event];
        }
      }
      this.merge(this, _DEFAULTS);
      if (options.form != null) {
        this.url = options.form.action;
        this.method = options.form.method;
        this.data = new FormData(options.form);
      }
      this.merge(this, options);
    }

    Request.prototype.send = function() {
      this.xhr.addEventListener("progress", this._progressChange.bind(this));
      this.xhr.addEventListener("readystatechange", this._stateChange.bind(this));
      this.xhr.open(this.method, this.url, this.async, this.username, this.password);
      this._setRequestHeaders();
      this._emitter.emit("before", this.xhr);
      return this.xhr.send(this._requestData());
    };

    Request.prototype.abort = function() {
      return this.xhr.abort();
    };

    Request.prototype.on = function() {
      return this._emitter.on.apply(this._emitter, arguments);
    };

    Request.prototype.off = function() {
      return this._emitter.off.apply(this._emitter, arguments);
    };

    Request.prototype.addEventListener = function() {
      return this._emitter.on.apply(this._emitter, arguments);
    };

    Request.prototype.removeEventListener = function() {
      return this._emitter.off.apply(this._emitter, arguments);
    };

    Request.prototype._setRequestHeaders = function() {
      if (this._dataIsObject()) {
        return this.xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
      }
    };

    Request.prototype._progressChange = function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return (_ref = this._emitter).emit.apply(_ref, ["progress"].concat(__slice.call(args)));
    };

    Request.prototype._stateChange = function() {
      if (this.xhr.readyState !== XMLHttpRequest.DONE) {
        return;
      }
      this.response = new Response(this.xhr);
      if (!Request.interceptor || Request.interceptor(this.response)) {
        if (this.response.success) {
          this._emitter.emit("success", this.response);
        } else {
          this._emitter.emit("error", this.response);
        }
      }
      return this._emitter.emit("complete", this.response);
    };

    Request.prototype._dataIsObject = function() {
      return this.data && this.data.constructor === Object;
    };

    Request.prototype._requestData = function() {
      if (this._dataIsObject()) {
        return JSON.stringify(this.data);
      }
      return this.data;
    };

    return Request;

  })();

  Response = (function() {
    function Response(xhr) {
      this.xhr = xhr;
      this.status = this.xhr.status;
      this.data = this._parseResponse();
      this.success = this._wasSuccess();
    }

    Response.prototype._parseResponse = function() {
      try {
        return JSON.parse(this.xhr.responseText);
      } catch (_error) {
        return this.xhr.responseText;
      }
    };

    Response.prototype._wasSuccess = function() {
      var _i, _ref, _results;
      return _ref = this.status, __indexOf.call((function() {
        _results = [];
        for (_i = 200; _i <= 299; _i++){ _results.push(_i); }
        return _results;
      }).apply(this), _ref) >= 0;
    };

    return Response;

  })();

}).call(this);
