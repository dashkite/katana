import * as _ from "@dashkite/joy/function"

# a simple arity function
arity = (f) -> if f.length == 0 then 1 else f.length

# enforce fn arity when applying
apply = _.curry (f, args) -> _.apply f, args[0...(arity f)]

# method variant of tee
tee = (f) ->
  _.arity f.length, (args...) ->
    f.apply this, args
    this

# call a function with a clone of an argument passing the original as well
clone = (f) ->
  _.arity f.length, (args..., daisho) ->
    apply f, [ args..., daisho.clone(), daisho ]

export {
  arity
  apply
  tee
  clone
}
