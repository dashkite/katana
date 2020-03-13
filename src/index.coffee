import {curry, pipe, tee, rtee} from "panda-garden"

arity = (f) -> if f.length == 0 then 1 else f.length

apply = curry (f, args) -> f.apply undefined, args

cover = curry (f, stack) ->  apply f, stack[0..(arity f)]

stack = (f) -> (args...) -> f args

spread = (f) -> (ax) -> f ax...

push = curry rtee (f, stack) ->
  stack.unshift await cover f, stack

pop = curry rtee (f, stack) ->
  await cover f, stack
  stack.shift()

mpop = curry rtee (f, stack) ->
  await cover f, stack
  stack.shift() for _ in [0..(arity f)]

peek = curry rtee (f, stack) -> cover f, stack

poke = curry rtee (f, stack) ->
  result = await cover f, stack
  stack.shift()
  stack.unshift result

mpoke = curry rtee (f, stack) ->
  result = await cover f, stack
  stack.shift() for _ in [0..(arity f)]
  stack.unshift result

test = curry rtee (predicate, action, stack) ->
  action stack if await cover predicate, stack

branch = curry rtee ([conditions..., fallback], stack) ->
  conditions.push fallback if !fallback.call?
  for [ predicate, action ] in conditions
    if await cover predicate, stack
      await action stack
      return
  fallback stack

dupe = tee (stack) -> stack.unshift stack[0]

restore = curry rtee (f, stack) -> f [ stack... ]

clear = (stack) -> []

stack = (f) -> (args...) -> f args

rack = curry rtee (g, f, stack) -> f g stack

nth = curry rtee (n, f, stack) -> f stack[(n - 1)..]

second = nth 2

third = nth 3

over = curry (f, [i, rest...]) ->
  f -> yield [ m, rest... ] for await m from i

log = curry rtee (label, stack) -> console.log [label]: stack

export {push, pop, peek, poke,
  mpop, mpoke,
  test, branch,
  restore, clear, dupe,
  rack, nth, second, third,
  over,
  apply, cover, stack, spread,
  log}
