import * as _ from "@dashkite/joy/function"
import * as _γ from "@dashkite/joy/generic"
import * as _τ from "@dashkite/joy/type"
import * as _ν from "@dashkite/joy/value"
import * as _ο from "@dashkite/joy/object"

import { tee, apply } from "./helpers"

_ο.assign _, _γ, _τ, _ν, _ο

create = _.generic
  name: "Daisho.create"
  description: "Create a Daisho data structure from an object and/or iterable"

_.generic create,
  _.isIterable, _.isDefined,
  (it, object) ->
    _.assign (new Daisho),
      stack: Array.from it
      context: object

_.generic create,
  _.isArray, _.isDefined,
  (array, object) ->
    _.assign (new Daisho),
      stack: array
      context: object

_.generic create,
  _.isDefined,
  (object) ->
    _.assign (new Daisho),
      stack: []
      context: object

_.generic create,
  _.isIterable,
  (it) ->
    _.assign (new Daisho),
      stack: Array.from it
      context: {}

_.generic create,
  _.isArray,
  (array) ->
    _.assign (new Daisho),
      stack: array
      context: {}

class Daisho

  @isDaisho: _.isKind Daisho

  @create: create

  @clone: ({stack, context}) -> @create [stack...], {context...}

  clone: -> Daisho.clone @

  push: tee (value) -> @stack.unshift value

  pushn: tee (values) -> @stack = [ values..., @stack... ]

  poke: tee (value) -> @stack[0] = value

  poken: tee (values) -> @stack = [ values..., @stack[ (values.length)..] ]

  pop: -> @stack.shift()

  popn: (n) -> (@stack.shift() for i in [0...n])

  peek: -> @stack[0]

  peekn: (n) -> @stack[0..n]

  apply: (f) -> apply f, @stack[0...f.length]

  read: (key) -> @context[key]

  write: tee (key, value) -> @context[key] = value

  assign: tee (stack) -> @context = stack.context

isDaisho = Daisho.isDaisho

daisho = (f) ->
  _.arity f.length, (args..., value) ->
    apply f, [
      args...
      if isDaisho value then value else Daisho.create value
    ]

export {
  Daisho
  isDaisho
  daisho
}
