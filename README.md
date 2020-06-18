# Katana

*Stack-based composition combinators in JavaScript.*

```coffeescript
flow [
  push -> 3
  push -> 4
  push add
  pop (sum) -> assert.equal sum, 7
  (stack) -> assert.equal stack.length, 0
]
```

## Table Of Contents

- [Installation](#installation)
- [Motivation](#motivation)
- [API](#api)

## Installation

```
npm i @dashkite/katana
```

Browser-compatible. Use with your favorite bundler.

### Motivation

Function composition is a powerful tool in theory, but in practice, it's often difficult for non-trivial scenarios because the arguments and return values of a given set of functions may not be amenable to simple composition. Stack-based composition provides generic context—the stack—and a set of combinators for adapting ordinary functions for use with it. This simplifies composition, even across libraries that were not designed to be used together. This is a key advantage of composition over chaining, which requires that each function be expressly added to an object as a method.

## API

When we _apply_ a function in a stack context, we use the arity of the function to determine how many elements from the stack to pass into the function. Applying a unary function will result in passing the top of the stack into the function. Applying a binary function will result in passing the first two elements from the stack into the function, and so on.

### Core

Functions prefixed with an _s_ are synchronous variants, ex: `spop`. Functions prefixed with an _m_ will alter the stack based on the arity of the given function, ex: `mpop`. These may be combined, ex: `smpop`. The unprefixed functions are asynchronous—that is, they will await on the given function—and only add, replace, or remove one element from the top of the stack, regardless of the arity of the function.

#### push fn | spush fn

Calls `f` with `arity f` elements from the top of the stack. The result is added to the top of the stack.

#### pop fn | spop fn | mpop fn | smpop fn

Calls  `f` with `arity f` elements from the top of the stack. The top of the stack is removed.

#### peek fn | speek fn

Calls  `f` with `arity f` elements from the top of the stack. The stack is unchanged.

#### poke fn | spoke fn | mpoke fn | smpop fn

Calls  `f` with `arity f` elements from the top of the stack. The top of the stack is replaced with the result.

#### pushn array | pushn array

Like `push`, but for an array of functions, pushing the result of each onto the stack.

### Context

The _context_ of the stack is, by convention, the bottom of the stack. The `read` and `write` functions operate on this element. This allows you to write stack functions that are independent of the state of the stack.

#### read name

Reads a property from the context and pushes it.

#### write name

Writes the element at the top of the stack to the context.

### Predicates

#### test predicate, action | stest predicate, action

Calls  `predicate` with `arity predicate` elements from the top of the stack and calls `action` with the stack if the result is true.

#### branch conditions | sbranch conditions

Given an array of `conditions` whose elements are `predicate, action` pairs, calls` `predicate` with `arity predicate` elements from the top of the stack and calls `action` with the stack if the result is true, for each pair, until one is true.

The array may optionally take a last element as a default action (whose predicate is implicitly true).

### Iteration

#### over fn

Given an iterator as the first element of the stack, composes a new iterator who values are the values produced by the original iterator and the remainder of the stack. The resulting iterator is passed to the given function. This allows arbitrarily sophisticated forms of iteration without losing the stack.

```
f = over (filter apply even), poke square
assert.equal [1, 9, 25], await f [1..5]
```

### Convenience

#### discard

Discard the element at the top of the stack. Equvalent to `pop ->` but faster and there’s no need for a synchronous variant.

#### apply fn

Calls  `f` with `arity f` elements from the top of the stack and returns the result. Stack-based analog to [`Function::apply`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/apply).


#### stack fn

Takes a stack function and returns a non-stack function that will take an argument list, transform it into a stack, and calling the original function with the resulting stack.

#### spread fn

Takes an non-stack function and returns a function that will take a stack, calling the original function with the elements of the stack as arguments.

#### log label

Logs the stack using `console.debug` using the given label.