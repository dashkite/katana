import * as _ϝ from "@dashkite/joy/function"
import * as _τ from "@dashkite/joy/type"
import * as _ο from "@dashkite/joy/object"
_ = _ο.merge _ϝ, _τ

import { Daisho, daisho } from "./daisho"
import { arity, clone } from "./helpers"

push = _.curry daisho clone (f, daisho) -> daisho.push daisho.apply f

pop = _.curry daisho clone _.rtee (f, daisho) ->
  daisho.apply f
  daisho.pop()

discard = daisho clone _.rtee (daisho) -> daisho.pop()

peek = _.curry daisho _.rtee (f, daisho) -> daisho.apply f

poke = _.curry daisho clone (f, daisho) -> daisho.poke daisho.apply f

pushn = _.curry daisho clone (fx, daisho) ->
  daisho.pushn (daisho.apply f for f from fx)

mpop = _.curry daisho clone _.rtee (f, daisho) ->
  daisho.apply f
  daisho.popn arity f

mpoke = _.curry _.binary daisho clone (f, daisho, original) ->
  daisho.popn arity f
  daisho.push original.apply f
  daisho

test = _.curry daisho (predicate, action, daisho) ->
  if (daisho.apply predicate) == true
    action daisho
  else
    daisho

branch = _.curry daisho (conditions, daisho) ->
  for [predicate, action] in conditions
    if (daisho.apply predicate) == true
      return action daisho
  daisho

assign = _.curry _.binary daisho clone (f, daisho, original) ->
  if _.isArray f then f = _.pipe f
  daisho.assign f original

read = _.curry daisho clone (name, daisho) -> daisho.push daisho.read name

write = _.curry daisho clone (name, daisho) -> daisho.write name, daisho.peek()

stack = daisho clone (daisho) -> daisho.push daisho.stack

context = daisho clone (daisho) -> daisho.push daisho.context

get = daisho (daisho) -> daisho.pop()

export { Daisho, isDaisho } from "./daisho"

export {
  push
  pop
  discard
  peek
  poke
  pushn
  mpop
  mpoke
  test
  branch
  assign
  read
  write
  stack
  context
  get
}
