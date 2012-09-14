# @requires ../store
# @requires ../../utils/request
window.Store.Request = class Store.XHR
  init: (callback) ->
    @request = new Request @prefix
    callback @
  get: (key, callback) ->
    @request.get {key:key}, (response) =>
      console.log response.body
      callback? @deserialize response.body
  set: (key, value, callback) ->
    @request.post {key:key, value: @serialize value}, (response) =>
      callback? response.body
  list: (callback) ->
    @request.get (response) =>
      callback? response.body
  remove: (key, callback) ->
    @request.delete {key:key}, (response) =>
      callback? response.body
