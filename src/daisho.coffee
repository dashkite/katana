import * as _ from "@dashkite/joy/function"
import * as _τ from "@dashkite/joy/type"
import * as _ν from "@dashkite/joy/value"
import * as _ο from "@dashkite/joy/object"

import { tee, apply } from "./helpers"

_ο.assign _, _τ, _ν, _ο

class Daisho

  @isDaisho: _.isKind Daisho

  @create: (it, context = {}) ->
    _.assign (new Daisho),
      _stack: Array.from it
      _context: context

  @clone: ({_stack, _context}) -> @create _stack, _.clone _context

  clone: -> Daisho.clone @

  push: tee (value) -> @_stack.unshift value

  pushn: tee (values) -> @_stack = [ values..., @_stack... ]

  poke: tee (value) -> @_stack[0] = value

  poken: tee (values) -> @_stack = [ values..., @_stack[ (values.length)..] ]

  pop: -> @_stack.shift()

  popn: (n) -> (@_stack.shift() for i in [0...n])

  peek: -> @_stack[0]

  peekn: (n) -> @_stack[0..n]

  apply: (f) -> apply f, @_stack[0...f.length]

  read: (key) -> @_context[key]

  write: tee (key, value) -> @_context[key] = value

  copy: tee (stack) -> @_context = stack._context

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
