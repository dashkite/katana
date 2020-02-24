import {curry, tee, rtee} from "panda-garden"

_arity = (f) -> if f.length == 0 then 1 else f.length

_push = (stack, value) -> stack.unshift value
_pop = (stack, n) ->
  while stack.length > 0 && n-- > 0
    stack.shift()
_peek = (stack, n) -> stack[0...n]
_append = (stack, value) -> stack.push value
apply = (f, args) -> f args...

push = curry rtee (f, stack) ->
  _push stack, await apply f, _peek stack, _arity f

pop = curry rtee (f, stack) ->
  apply f, _pop stack, _arity f

peek = curry rtee (f, stack) ->
  apply f, _peek stack, _arity f

replace = curry rtee (f, stack) ->
  _push stack, await apply f, _pop stack, _arity f

copy = curry tee (stack) ->
  _push stack, (_peek stack, 1)...

export {push, pop, peek, replace, copy}
