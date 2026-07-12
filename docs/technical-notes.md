# Technical Notes

## Design Choices

### Flatten Behavior

The `flatten` operator pushes each item an iterable produces onto the stack in reverse order. This ensures the first item produced ends up at the top of the stack. This operation is necessary because relying solely on array functions like `Array::flat` would simply return the array without distributing its elements across the stack.

### Arity-Based Extraction

The core stack combinators (`push`, `pop`, `peek`, and `poke`) apply a function and use the arity of the function to determine how many elements from the stack to pass into it. Applying a unary function passes the top of the stack. Applying a binary function passes the first two elements.

### Asynchronous Functions

Stack combinators that accept asynchronous functions return a promise. Creators should ensure that their composition function handles promises correctly when incorporating asynchronous functions into the pipeline.

## Paradigms

### Stack-Oriented Programming and Point-Free Notation

Katana embraces [stack-oriented programming](https://en.wikipedia.org/wiki/Stack-oriented_programming), a paradigm that relies on a stack data structure to pass parameters between functions. This paradigm pairs naturally with **point-free notation** (or tacit programming). 

In point-free style, function definitions do not explicitly identify the arguments (or "points") on which they operate. Instead, functions are constructed by composing other functions and combinators that manipulate the stack. By operating directly on the stack rather than explicitly managing local variables, developers can construct compositional flows that are declarative, expressive, and easier to reason about when handling complex intermediate state.
