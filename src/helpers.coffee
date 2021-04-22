import * as _ from "@dashkite/joy/function"

# a simple arity function
arity = (f) -> if f.length == 0 then 1 else f.length

# a stack-aware version of apply
apply = _.curry (f, stack) ->
  n = (arity f) - 1
  _.apply f, stack[0..n]

export {
  arity
  apply
}
