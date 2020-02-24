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

copy = tee (stack) ->
  _push stack, (_peek stack, 1)...

test = curry rtee (p, f, stack) ->
  f stack if (await apply p, _peek stack, _arity p)

restore = curry tee (f, original) -> f Array.from stack

clear = tee (stack) -> []

log = (stack) -> console.log {stack}

export {push, pop, peek, replace, copy, test, restore, clear, log}
