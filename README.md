# Katana

*Stack-based composition combinators in JavaScript.*

```coffeescript
flow [
  push -> 3
  dupe
  push add
  pop (sum) -> assert.equal sum, 6
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

*push f, stack → stack*

Calls *f* with *arity f* elements from the top of the stack. The result is added to the top of the stack.

#### pop

*pop f, stack → stack*

Calls  *f* with *arity f* elements from the top of the stack. The top of the stack is removed.

#### peek

*peek f, stack → stack*

Calls  *f* with *arity f* elements from the top of the stack. The stack is unchanged.

#### poke

*poke f, stack → stack*

Calls  *f* with *arity f* elements from the top of the stack. The top of the stack is replaced with the result.

### Predicate Combinators

#### test

*test predicate, action, stack → stack*

Calls  *predicate* with *arity predicate* elements from the top of the stack and calls *action* with the stack if the result is true.

#### branch

*branch conditions, stack → stack*

Given an array of *conditions* whose elements are *predicate, action* pairs, calls* *predicate* with *arity predicate* elements from the top of the stack and calls *action* with the stack if the result is true, for each pair, until one is true.

The array may optionally take a last element as a default action (whose predicate is implicitly true).

### m* (Arity) Combinators

These functions remove elements from the stack based on the arity of the given function.

#### mpop

*mpop f, stack → stack*

Calls  *f* with *arity f* elements from the top of the stack. The top *arity f* elements of the stack are removed.

#### mpoke

*poke f, stack → stack*

Calls  *f* with *arity f* elements from the top of the stack. The top *arity f* elements of the stack are replaced with the result.

### Stack Mutators

#### restore

*restore f, stack → stack*

Calls *f* with a **shallow** clone of *stack*. The original stack is returned.

> **Important ▸** If the elements of the cloned stack are changed, they will also be changed in the original stack, because the stack is only a shallow copy of the original. However, if the elements are *replaced*, those elements will not be in the original stack.
>
> If you want a deep clone, use *rack clone*.

#### clear

*clear stack → stack*

Returns an empty stack.

#### dupe

*dupe stack → stack*

Takes the top of the stack and adds it again to the top. Equivalent to `spush first`.

### Stack Adapters

#### Rack

*rack g, f, stack → stack*

Calls *f* with *g stack*. Returns the original stack.

#### nth

*nth n, f, stack → stack*

Calls *f* with *stack*, beginning with the *nth* element. Returns the original stack.

#### second

*second f, stack → stack*

Calls *f* with *stack*, beginning with the second element. Returns the original stack.

#### third

*third f, stack → stack*

Calls *f* with *stack*, beginning with the third element. Returns the original stack.

### Stack Iteration

#### over

*over f, g, stack → stack*

Calls *f* with the first element and iterates over the result, calling *g*, with the stack formed by each element and the remainder of the stack. Returns the stack.

### Convenience Combinators

#### arity

*arity f*

Returns the minimal arity of f. If f is variadiac, returns 1.

> **Important ▸** This is different from _arity_ in [@pandastrike/garden](https://github.com/pandastrike/garden), which returns the given function with the a given arity value.

#### apply

*apply f, array → any*

Calls  *f* with *array* arguments.

#### cover

*cover f, stack → any*

Calls  *f* with *arity f* elements from the top of the stack and returns the result.


#### stack

*stack f → f*

Takes a stack function and returns a function that will take an argument list, transform it into a stack, and calling the original function with the resulting stack.

#### spread

*spread f → f*

Takes an ordinary function and returns a function that will take a stack, calling the original function with the elements of the stack as arguments.

