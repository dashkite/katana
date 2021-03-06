import * as _ϝ from "@dashkite/joy/function"
import * as _τ from "@dashkite/joy/type"
import * as _ο from "@dashkite/joy/object"
_ = _ο.merge _ϝ, _τ

import { Daisho, daisho } from "./daisho"
import { arity, clone } from "./helpers"

push = _.curry daisho clone (f, daisho) -> daisho.push await daisho.apply f

pop = _.curry daisho clone _.rtee (f, daisho) ->
  await daisho.apply f
  daisho.pop()

peek = _.curry daisho _.rtee (f, daisho) -> daisho.apply f

poke = _.curry daisho clone (f, daisho) -> daisho.poke await daisho.apply f

pushn = _.curry daisho clone (fx, daisho) ->
  daisho.pushn ((await daisho.apply f) for f from fx)

mpop = _.curry daisho clone _.rtee (f, daisho) ->
  await daisho.apply f
  daisho.popn arity f

mpoke = _.curry _.binary daisho clone (f, daisho, original) ->
  daisho.popn arity f
  daisho.push await original.apply f

test = _.curry daisho (predicate, action, daisho) ->
  if (await daisho.apply predicate) == true
    action daisho
  else
    daisho

branch = _.curry daisho (conditions, daisho) ->
  for [predicate, action] in conditions
    if (await daisho.apply predicate) == true
      return action daisho
  daisho

assign = _.curry _.binary daisho clone (f, daisho, original) ->
  if _.isArray f then f = _.flow f
  daisho.assign await f original

# so that you don't have to import these separately
export { Daisho, isDaisho } from "./daisho"

export {
  discard
  read
  write
  stack
  context
  get
} from "./sync"

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
  assign
}
