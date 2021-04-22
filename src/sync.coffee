import * as _ from "@dashkite/joy/function"
import { arity, apply } from "./helpers"

push = _.curry (f, stack) -> [ (apply f, stack), stack... ]
pop = _.curry (f, stack) -> apply f, stack ; stack[1..]
peek = _.curry (f, stack) -> apply f, stack ; stack
poke = _.curry (f, stack) -> [ (apply f, stack), stack[1..]... ]
pushn = _.curry (fx, stack) ->
  [ ((apply f, stack) for f from fx)..., stack... ]

mpop = _.curry (f, stack) -> apply f, stack ; stack[(arity f)..]
mpoke = _.curry (f, stack) -> [ (apply f, stack), stack[(arity f)..]... ]

test = _.curry (predicate, action, stack) ->
  if (apply predicate, stack) == true
    action stack
  else
    stack

branch = _.curry (conditions, stack) ->
  for [predicate, action] in conditions
    if (apply predicate, stack) == true
      return action stack
  stack

copy = _.curry (f, stack) ->
  [ rest..., context ] = stack
  [ ..., _context ] = f stack
  [ rest..., _context ]

# just in case so you don't have to import these separately
export { read, write, discard } from "./async"

export {
  push
  pop
  peek
  poke
  pushn
  mpop
  mpoke
  test
  branch
  copy
}
