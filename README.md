# Katana

*Daisho (stack- and context-based) composition combinators in JavaScript.*

```coffeescript
import {pipe} from "@dashkite/joy/function"
import {push, mpush, pop, stack} from "@dashkite/katana/sync"

pipe [
  push -> 3
  push -> 4
  mpush add
  pop (sum) -> assert.equal sum, 7
  stack
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

Browser-compatible. Use with your favorite bundler or import directly.

### Motivation

Function composition is a powerful tool in theory, but in practice, it's often difficult for non-trivial scenarios because the arguments and return values of a given set of functions may not be amenable to simple composition. Stack-based composition provides generic context—the stack—and a set of combinators for adapting ordinary functions for use with it. This simplifies composition, even across libraries that were not designed to be used together. This is a key advantage of composition over chaining, which requires that each function be expressly added to an object as a method.

#### Daisho Data Structure

However, stack-based composition can lead to code that is difficult to reason about. Combining a stack with a context object makes possible variety of compositional scenarios. Context-based composition is the basis for method-chaining, or fluent, programming, popularized by jQuery, where the target object serves as the context. We call this hybrid stack/object data structure a _daisho_, because of its dual nature. We can use the stack for simple composition and the context for complex composition. In combination, we may use the stack to compute results we place into the context for later use.

## API

Stack operations always apply a function, using the arity of the function to determine how many elements from the stack to pass into the function and possibly to remove from the stack. Applying a unary function will result in passing the top of the stack into the function. Applying a binary function will result in passing the first two elements from the stack into the function, and so on. Context operations do not apply a function, but simply move data to and from the context.

There are synchronous and asynchrouns variants for operations that apply a function. By default, when importing Katana, you get the asynchronous versions. These are bit slower since they yield control of the event loop after each operation that applies a function (since the function may return a promise). You may load the synchronous versions using a subpath:

```coffeescript
import {push, pop} from "@dashkite/katana/sync"
```

You can load both variants using the wildcard import:

```coffeescript
import * as ks from "@dashkite/katana/sync"
import * as ka from "@dashkite/katana/async"
```

Keep in mind that the async variants that apply a function will return a promise.

### Mutability

Operations that mutate the given daisho operate on and return a clone. However, keep in mind that the values _within_ it are not cloned (that is, it is not a deep clone).

### Creating A Daisho

*Daisho.create object → daisho*

*Daisho.create iterable → daisho*

*Daisho.create iterable, object → daisho*

*Daisho.create object, iterable → daisho*

You may create a Daisho using an iterable, object, or both, in any order. The stack will be constructed from an iterable using `Array.from`. If you pass in an array, however, it will be used directly.

### Stack Operations

Functions prefixed with an _m_ will alter the stack based on the arity of the given function, ex: `mpop`, will not only pass *arity* elements to the given function, but will subsequently remove those elements from the stack (instead of just the first element).

#### push

*push f, daisho → daisho*

Calls `f` with `arity f` elements from the top of the stack. The result is added to the top of the stack.

#### pop | mpop

*pop f, daisho → daisho*

Calls  `f` with `arity f` elements from the top of the stack. The top of the stack is removed.

#### peek

*peek f, daisho → daisho*

Calls  `f` with `arity f` elements from the top of the stack. The stack is unchanged.

#### poke | mpoke

*poke f, daisho → daisho*

Calls  `f` with `arity f` elements from the top of the stack. The top of the stack is replaced with the result.

#### pushn

*pushn array\<function\>, daisho → daisho*

Like `push`, but for an array of functions, pushing the result of each onto the stack.

#### discard

*discard daisho → daisho*

Discard the element at the top of the stack. Equvalent to `pop ->` but faster and there’s no need for a synchronous variant.

### Context Operations

The `read` and `write` functions operate on the context.

#### read

*read name, daisho → daisho*

Reads a property from the context and pushes it.

#### write

*write name, daisho → daisho*

Writes the element at the top of the stack to the context.

#### assign

*assign f, daisho → daisho*

Applies the function, which should take and return a daisho as an argument and sets the context based on the returned context. Useful for performing a computation and writing the result to the context while discarding any changes to the stack. 

### Predicates

#### test predicate, action

Calls  `predicate` with `arity predicate` elements from the top of the stack and calls `action` with the stack if the result is true.

#### branch conditions

Given an array of `conditions` whose elements are `predicate, action` pairs, calls` `predicate` with `arity predicate` elements from the top of the stack and calls `action` with the stack if the result is true, for each pair, until one is true.

The array may optionally take a last element as a default action (whose predicate is implicitly true).

### Accessors

#### stack

*daisho → stack*

Returns the stack.

#### context

*daisho → context*

Returns the context.

#### get

*daisho → value*

Returns the top of the stack.