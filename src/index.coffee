import {curry} from "@pandastrike/garden"

_apply = curry (f, args) -> f.apply undefined, args
_arity = (f) -> if f.length == 0 then 1 else f.length
apply = curry (f, stack) ->  _apply f, stack[0..(_arity f)]

# general variants
push = curry (f, stack) -> [ (await apply f, stack), stack... ]
pop = curry (f, stack) -> await apply f, stack ; stack[1..]
peek = curry (f, stack) -> await apply f, stack ; stack
poke = curry (f, stack) -> [ (await apply f, stack), stack[1..]... ]
pushn = curry (fx, stack) ->
  [ (await Promise.all ((apply f, stack) for f from fx))..., stack... ]

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

rack = curry (g, f, stack) -> f g stack

nth = curry (n, f, stack) -> f stack[(n - 1)..]

second = nth 2

third = nth 3

over = curry (f, [i, rest...]) ->
  f -> yield [ m, rest... ] for await m from i

stack = (f) -> (args...) -> f args

spread = (f) -> (ax) -> f ax...

log = curry (label, stack) -> console.log [label]: stack ; stack

# TODO why isn't this in parchment?
reverse = (ax) -> ax.reverse()

last = (ax) -> ax[ax.length - 1]


export {apply, stack, spread,
  push, pop, peek, poke, pushn
  mpop, mpoke,
  test, branch,
  spush, spop, speek, spoke, spushn
  smpop, smpoke,
  stest, sbranch,
  rack, nth, second, third,
  over,
  log}
