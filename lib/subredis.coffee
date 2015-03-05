redis = require 'redis'
coredis = require 'co-redis'
module.exports = exports = class Redis extends redis.RedisClient
  constructor: (options) ->
    unless @ instanceof Redis
      return new Redis options
    {port, host, path, debug_mode} = options?
    if debug_mode is on
      redis.debug_mode = on
    if path
      @sub = coredis redis.createClient path, options
      @__proto__ = redis.createClient path, options
    else
      @sub = coredis redis.createClient port, host, options
      @__proto__ = redis.createClient port, host, options
    coredis @
    for name in ['addListener', 'on', 'once', 'removeListener', 'removeAllListeners', 'setMaxListeners', 'emit']
      method = @[name]
      @[name] = (...args) ->
        method.apply @, args
        method.apply @sub, args
    for name in ['subscribe', 'psubscribe', 'unsubscribe', 'unpsubscribe']
      @[name] = @sub[name].bind @sub

Object.defineProperties exports,
  debug_mode:
    get: ->
      redis.debug_mode
    set: (debug_mode) ->
      redis.debug_mode = debug_mode
  print:
    get: ->
      redis.print
    set: (print) ->
      redis.print = print
