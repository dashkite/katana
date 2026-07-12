# Katana

*Combinators for stack-based composition in JavaScript.*

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

Functional programming promotes building reliable software. Function composition combines modular, well-tested functions to construct complex systems while maintaining ease of maintenance. Stack-based composition addresses challenges in function composition by making it easier to compose non-unary functions in a point-free style. 

## Features

- Compose binary or multi-arity functions using stack-based combinators.
- Integrate with standard functional programming libraries.
- Support asynchronous function composition natively via promises.
- Provide core stack operations like push, pop, peek, and poke.

## Installation

Install Katana using pnpm:

```shell
pnpm install @dashkite/katana
```

## Usage

Katana provides combinators like `push`, `pop`, and `poke` to manipulate a stack within a function composition pipeline.

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

## Other Resources

- [Recipes](docs/recipes.md)
- [Reference](docs/reference.md)
- [Technical Notes](docs/technical-notes.md)
- [Testing](docs/testing.md)
