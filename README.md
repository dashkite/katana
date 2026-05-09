# Katana

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

*Combinators for stack-based composition in JavaScript.*

```coffeescript
import { pipe } from "@dashkite/joy/function"
import { push, pop, poke } from "@dashkite/katana"

pipe [
  push -> 1
  push -> 2
  poke ( x, y ) -> x + y
  pop ( z ) -> assert.equal 3, z
  ( stack ) -> assert.equal stack.length, 0
]
```

## Table Of Contents

- [Installation](#installation)
- [Motivation](#motivation)
- [API](#api)

## Installation

Install Katana as `@dashkite/katana` using your favorite package manager. To use Katana in a browser, import it directly or use your favorite bundler.

## Motivation

Functional programming is often promoted as a way to build more reliable software. In particular, function composition promises to make it possible to combine modular and well-tested functions to build more complex systems without sacrificing reliability or ease of maintenance.

In practice, one of the challenges is that composition can be difficult. Function signatures don’t always line up neatly, forcing awkward compromises that may be difficult to understand or reason about. In contrast, imperative code with intermediate state, though perhaps less elegant, may ultimately be more expressive.

Stack-based composition is an attempt to address this challenge by making it easier to compose binary (or non-unary) functions in a [point-free](https://en.wikipedia.org/wiki/Tacit_programming) style. For example, consider a binary function, _encrypt_, taking a key and message (the plaintext). We might write this imperatively like this:

```coffeescript
encryptWithKeyName = ( message, name ) ->
  key = await getKey name
  encrypt message, key
```

If we wanted to use composition here, we’d need a way to compose `encrypt` with `getKey`. However, because `encrypt` is a binary function, it’s unclear how we might do this. 

Stack-based composition solves this problem by composing over a stack, so that both the key and message are available (the top of the stack is the rightmost value, at the end of the array):

```coffeescript
encryptWithKeyName = pipe [
  pair                             # [ message, key-name ]
  poke getKey                      # [ message, key ]
  swap                             # [ key, message ]
  poke encrypt                     # [ encrypted-message ]
  first                            # => encrypted-message
]
```

For such a simple function, we might well prefer to use the imperative style. However, for more complex cases, being able to rely strictly on composition makes it easier realize the advantages of functional programming.

## API

The core stack combinators—push, pop, peek, and poke—apply a function, using the arity of the function to determine how many elements from the stack to pass into it, and, in the case of pop and poke, to remove from the stack. Applying a unary function will result in passing the top of the stack into the function. Applying a binary function will result in passing the first two elements from the stack into the function, and so on. Other stack operators, such as drop and copy, simply operate on the stack directly.

You can compose function with any composition function from your favorite functional programming library. Stack combinators that take asynchronous functions will return a promise, so your composition function should handle promises if you’re using asynchronous functions.

## Reference

### push

_push f, stack → stack_

Call _f_ with _k_ items from the stack, where _k_ is the arity of _f_. Push the return value onto the stack.

### pop

_pop f, stack → stack_

Call _f_ with _k_ items from the stack, where _k_ is the arity of _f_. Pops the items from the stack.

### poke, replace

_poke f, stack → stack_

Call _f_ with _k_ items from the stack, where _k_ is the arity of _f_. Pops the items from the stack. Push the return value onto the stack. Alias: _replace_.

### peek

_peek f, stack → stack_

Call _f_ with _k_ items from the stack, where _k_ is the arity of _f_. Leaves the stack unchanged.

### drop, discard

_drop stack → stack_

Pops the stack. Equivalent to `pop ( x ) ->`

### up

_up stack → stack_

Rotates the items on the stack, pushing items up, while the top of the stack goes to the bottom.

```coffeescript
do pipe [
  -> [ 1..5 ]      # [ 1, 2, 3, 4, 5 ]
  up               # [ 5, 1, 2, 3, 4 ]
]
```

### down

_down stack → stack_

Rotates the items on the stack, pushing items down, while the bottom of the stack goes to the top.

```coffeescript
do pipe [
  -> [ 1..5 ]     # [ 1, 2, 3, 4, 5 ]
  down            # [ 2, 3, 4, 5, 1 ]
]
```

### swap

_swap stack → stack_

Swaps the first two items on the stack, so the first becomes the second and vice-versa.

### copy, duplicate

_copy stack → stack_

Copies the top item on the stack.

### flatten

_flatten stack → stack_

If the first item of the stack is an iterable, push each item it produces onto the stack. Items are added in the reverse order from when they’re produced, so that the first item produced will be at the top of the stack.

If it’s not an iterable, do nothing.

```coffeescript
do pipe [
  -> []           # []
  push [ 1..5 ]   # [[ 1..5 ]]
  flatten         # [ 5, 4, 3, 2, 1 ]
]
```

> [!Note]
>
> The reason we need this operator—rather than just relying on array functions—is because there’s no simple way to do this otherwise. For example, using `Array::flat` would just add back the array.

### stack

_stack stack → stack_

Place the stack on the stack as an array, removing all the other items.
