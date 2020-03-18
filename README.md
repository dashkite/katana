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

Function composition is a powerful tool in theory, but in practice, it's often difficult for non-trivial scenarios because the arguments and return values of a given set of functions may not be amenable to simple composition. One solution to that problem is to create a “context” type, which each functions takes and returns, thus ensuring they're composable. However, this means you must often write wrapper functions that “know” about the context to use functions that don't.

Stack-based composition provides generic context—the stack—and a set of combinators for adapting ordinary functions for use with it. This eliminates the need for domain-specific context type without sacrificing the ability to compose functions, possibly from different libraries. This is a key advantage of composition over chaining, which requires that each function be expressly added to an object as a method.

## API

### Core Combinators

#### push

`push f, stack → stack`

Calls `f` with `arity f` elements from the top of the stack. The result is added to the top of the stack.

#### pop

`pop f, stack → stack`

Calls  `f` with `arity f` elements from the top of the stack. The top of the stack is removed.

#### peek

`peek f, stack → stack`

Calls  `f` with `arity f` elements from the top of the stack. The stack is unchanged.

#### poke

`poke f, stack → stack`

Calls  `f` with `arity f` elements from the top of the stack. The top of the stack is replaced with the result.

### Predicate Combinators

#### test

`test predicate, action, stack → stack`

Calls  `predicate` with `arity predicate` elements from the top of the stack and calls `action` with the stack if the result is true.

#### branch

`branch conditions, stack → stack`

Given an array of `conditions` whose elements are `predicate, action` pairs, calls` `predicate` with `arity predicate` elements from the top of the stack and calls `action` with the stack if the result is true, for each pair, until one is true.

The array may optionally take a last element as a default action (whose predicate is implicitly true).

### m* (Arity) Combinators

These functions remove elements from the stack based on the arity of the given function.

#### mpop

`mpop f, stack → stack`

Calls  `f` with `arity f` elements from the top of the stack. The top `arity f` elements of the stack are removed.

#### mpoke

`poke f, stack → stack`

Calls  `f` with `arity f` elements from the top of the stack. The top `arity f` elements of the stack are replaced with the result.

### Stack Adapters

Transform the stack for use with a given function.

#### rack

`rack g, f, stack → stack`

Calls `f` with `g stack`. Returns the original stack. This can be used with functions that manipulate arrays, like _reverse_ or _rotate_ (not defined as a part of Katana) to provide different views of the stack.

#### nth

`nth n, f, stack → stack`

Calls `f` with `stack`, beginning with the `n`th element. Returns the original stack.

#### second

`second f, stack → stack`

Calls `f` with `stack`, beginning with the second element. Returns the original stack.

#### third

`third f, stack → stack`

Calls `f` with `stack`, beginning with the third element. Returns the original stack.

### Stack Iteration

#### over

`over f, stack → stack`

Given an iterator as the first element of the stack, composes a new iterator who values are the values produced by the original iterator and the remainder of the stack. The resulting iterator is passed to the given function. This allows arbitrarily sophisticated forms of iteration.

#### Example

Given a function `filter` that produces only elements that satisfy a given predicate:

```coffeescript
f = over (filter apply even), poke square
assert.equal [1, 9, 25], await f [1..5]
```

### Convenience Combinators

#### apply

`apply f, stack → any`

Calls  `f` with `arity f` elements from the top of the stack and returns the result. Stack-based analog to [`Function::apply`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/apply).


#### stack

`stack f → f`

Takes a stack function and returns a non-stack function that will take an argument list, transform it into a stack, and calling the original function with the resulting stack.

#### spread

`spread f → f`

Takes an non-stack function and returns a function that will take a stack, calling the original function with the elements of the stack as arguments.
