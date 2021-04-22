import * as _ from "@dashkite/joy/function"
import * as _a from "@dashkite/joy/array"
import { arity, apply } from "./helpers"

# general variants
push = _.curry (f, stack) -> [ (await apply f, stack), stack... ]
pop = _.curry (f, stack) -> await apply f, stack ; stack[1..]
peek = _.curry (f, stack) -> await apply f, stack ; stack
poke = _.curry (f, stack) -> [ (await apply f, stack), stack[1..]... ]
pushn = _.curry (fx, stack) ->
  [ (await Promise.all ((apply f, stack) for f from fx))..., stack... ]
discard = (stack) -> stack[1..]

# m* variants
mpop = _.curry (f, stack) -> await apply f, stack ; stack[(arity f)..]
mpoke = _.curry (f, stack) -> [ (await apply f, stack), stack[(arity f)..]... ]

test = _.curry (predicate, action, stack) ->
  if (await apply predicate, stack) == true
    action stack
  else
    stack

branch = _.curry (conditions, stack) ->
  for [predicate, action] in conditions
    if (await apply predicate, stack) == true
      return action stack
  stack

read = _.curry (name, stack) ->
  [ ..., context ] = stack
  [ context[name], stack... ]

write = _.curry (name, stack) ->
  [ rest..., context ] = stack
  [ rest..., { context..., [name]: _a.first stack } ]

copy = _.curry (f, stack) ->
  [ rest..., context ] = stack
  [ ..., _context ] = await f stack
  [ rest..., _context ]

export {
  push
  pop
  peek
  poke
  pushn
  discard
  read
  write
  copy
  mpop
  mpoke
  test
  branch
}
