import {curry, pipe, tee, rtee, flow} from "panda-garden"

_apply = curry (f, args) -> f.apply undefined, args
_arity = (f) -> if f.length == 0 then 1 else f.length
apply = curry (f, stack) ->  _apply f, stack[0..(_arity f)]

# general variants
push = curry (f, stack) -> [ (await apply f, stack), stack... ]
pop = curry (f, stack) -> await apply f, stack ; stack[1..]
peek = curry (f, stack) -> await apply f, stack ; stack
poke = curry (f, stack) -> [ (await apply f, stack), stack[1..]... ]

# m* variants
mpop = curry (f, stack) -> await apply f, stack ; stack[(_arity f)..]
mpoke = curry (f, stack) -> [ (await apply f, stack), stack[(_arity f)..]... ]

test = curry (predicate, action, stack) ->
  if await predicate stack
    action stack
  else
    stack

branch = curry (conditions, stack) ->
  for [predicate, action] in conditions
    if await predicate stack
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

log = curry rtee (label, stack) -> console.log [label]: stack

# TODO why isn't this in parchment?
reverse = (ax) -> ax.reverse()

last = (ax) -> ax[ax.length - 1]

cast = (g, fx) ->
  stack flow [ (push f for f in reverse fx)..., (mpoke g), last ]

export {apply, stack, spread,
  push, pop, peek, poke,
  mpop, mpoke,
  test, branch,
  rack, nth, second, third,
  over,
  log,
  cast}
