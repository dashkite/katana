import {curry} from "@pandastrike/garden"

# first, a simple function wrapper for f.apply
_apply = curry (f, args) -> f.apply undefined, args
# second, a simple arity function
_arity = (f) -> if f.length == 0 then 1 else f.length
# third, a stack-aware version of apply
apply = curry (f, stack) ->  _apply f, stack[0..(_arity f)]
# simple helper for use with read/write
last = (ax) -> ax[ax.length - 1]

# general variants
push = curry (f, stack) -> [ (await apply f, stack), stack... ]
pop = curry (f, stack) -> await apply f, stack ; stack[1..]
peek = curry (f, stack) -> await apply f, stack ; stack
poke = curry (f, stack) -> [ (await apply f, stack), stack[1..]... ]
pushn = curry (fx, stack) ->
  [ (await Promise.all ((apply f, stack) for f from fx))..., stack... ]

read = curry (name, stack) -> [ (last stack)[name], stack... ]
write = curry (name, stack) -> (last stack)[name] = stack[0] ; stack
discard = (stack) -> stack[1..]

# m* variants
mpop = curry (f, stack) -> await apply f, stack ; stack[(_arity f)..]
mpoke = curry (f, stack) -> [ (await apply f, stack), stack[(_arity f)..]... ]

test = curry (predicate, action, stack) ->
  if (await apply predicate, stack) == true
    action stack
  else
    stack

branch = curry (conditions, stack) ->
  for [predicate, action] in conditions
    if (await apply predicate, stack) == true
      return action stack
  stack

# sync variants
spush = curry (f, stack) -> [ (apply f, stack), stack... ]
spop = curry (f, stack) -> apply f, stack ; stack[1..]
speek = curry (f, stack) -> apply f, stack ; stack
spoke = curry (f, stack) -> [ (apply f, stack), stack[1..]... ]
spushn = curry (fx, stack) ->
  [ ((apply f, stack) for f from fx)..., stack... ]

smpop = curry (f, stack) -> apply f, stack ; stack[(_arity f)..]
smpoke = curry (f, stack) -> [ (apply f, stack), stack[(_arity f)..]... ]

stest = curry (predicate, action, stack) ->
  if (apply predicate, stack) == true
    action stack
  else
    stack

sbranch = curry (conditions, stack) ->
  for [predicate, action] in conditions
    if (apply predicate, stack) == true
      return action stack
  stack

over = curry (f, [i, rest...]) ->
  f -> yield [ m, rest... ] for await m from i

stack = (f) -> (args...) -> f args

spread = (f) -> (ax) -> f ax...

log = curry (label, stack) -> console.log [label]: stack ; stack

export {apply, stack, spread,
  push, pop, peek, poke, pushn,
  read, write, discard,
  mpop, mpoke,
  test, branch,
  spush, spop, speek, spoke, spushn
  smpop, smpoke,
  stest, sbranch,
  over, log}
