import { detach, curry, pipe } from "@dashkite/joy/function"

cat = detach Array::concat
reverse = detach Array::reverse

normalize = ( f ) ->
  ( g, it ) -> f g, 
    if it? then Array.from it else []

apply = ( f ) -> ( ax ) -> f.apply null, ax

push = curry normalize ( f, stack ) ->
  k = f.length
  do pipe [
    -> stack[-k..] 
    apply f
    ( item ) -> 
      stack.push item
      stack
  ]

pop = curry normalize ( f, stack ) ->
  k = f.length
  do pipe [
    -> stack[-k..]
    apply f
    -> stack[...-k]
  ]

peek = curry normalize ( f, stack ) ->
  k = f.length
  do pipe [
    -> stack[-k..]
    apply f
    -> stack
  ]

poke = curry normalize ( f, stack ) ->
  k = f.length
  do pipe [
    -> stack[-k..]
    apply f
    ( item ) -> 
      stack = stack[...-k]
      stack.push item
      stack
      
  ]

replace = poke

drop = discard = pop ( x ) ->

up = ([ rest..., last ]) ->
  [ last, rest... ]

down = ([ first, rest... ]) ->
  [ rest..., first ]

swap = ([rest..., second, first ]) ->
  [ rest..., first, second ]

copy = ([ rest..., first ]) ->
  [ rest..., first, first ]

duplicate = copy

flatten = ([ rest..., first ]) ->
  if Array.isArray first
    cat rest, reverse Array.from first
  else
    [ rest..., first ]
      
stack = ( items ) -> [ items ]

export { 
  push
  pop
  peek
  poke
  replace
  drop
  discard
  up
  down
  swap
  copy
  duplicate
  flatten
  stack
}
