# Recipes

## Composing Functions with Intermediate State

This recipe demonstrates how to compose binary functions using stack-based composition, which is helpful when dealing with intermediate state.

Katana enables this by composing over a stack, so that multiple arguments are available without resorting to imperative code. The top of the stack is the rightmost value.

```coffeescript
import { pipe } from "@dashkite/joy/function"
import { pair, first } from "@dashkite/joy/array"
import { poke, swap } from "@dashkite/katana"

# External complexity represented by comments
# getKey: (name) -> Promise<string>
# encrypt: (message, key) -> string

encryptWithKeyName = pipe [
  pair                             # [ message, key-name ]
  poke getKey                      # [ message, key ]
  swap                             # [ key, message ]
  poke encrypt                     # [ encrypted-message ]
  first                            # => encrypted-message
]
```

Algorithm:
1. Initialize the stack with the message and key name.
2. Use `poke` to apply the `getKey` function to the key name. This replaces the key name with the resolved key on the stack.
3. Use `swap` to reverse the top two items on the stack, placing the key before the message.
4. Use `poke` to apply the `encrypt` function to the message and key. This replaces the message and key with the encrypted message.
5. Extract the first item from the resulting stack to return the encrypted message.

## Rotating Stack Items

This recipe demonstrates how to rotate items on the stack.

Katana provides `up` and `down` combinators to shift stack items efficiently.

```coffeescript
import { pipe } from "@dashkite/joy/function"
import { up, down } from "@dashkite/katana"

do pipe [
  -> [ 1, 2, 3, 4, 5 ]
  up
]

do pipe [
  -> [ 1, 2, 3, 4, 5 ]
  down
]
```

Algorithm:
1. Provide an initial stack of items.
2. Apply `up` to move the top of the stack to the bottom, shifting other items up.
3. Alternatively, apply `down` to move the bottom of the stack to the top, shifting other items down.

## Flattening an Iterable on the Stack

This recipe demonstrates how to extract items from an iterable on the stack.

Katana provides the `flatten` combinator, which iterates over an item and pushes each of its elements onto the stack.

```coffeescript
import { pipe } from "@dashkite/joy/function"
import { push, flatten } from "@dashkite/katana"

do pipe [
  -> []
  push -> [ 1, 2, 3, 4, 5 ]
  flatten
]
```

Algorithm:
1. Start with an empty stack.
2. Push an iterable (like an array) onto the stack.
3. Apply `flatten` to remove the iterable from the top of the stack and push its elements individually, in reverse order, so the first element remains at the top.

## Duplicating and Discarding Stack Items

This recipe demonstrates how to selectively copy, examine, and remove items from the stack using `copy`, `peek`, and `drop`.

These operations allow developers to branch logic, evaluate side-effects without altering the stack, or clean up unneeded values before proceeding.

```coffeescript
import { pipe } from "@dashkite/joy/function"
import { push, copy, peek, drop } from "@dashkite/katana"

# External complexity represented by comments
# logValue: (value) -> void

processAndLog = pipe [
  -> []
  push -> "Configuration Data"
  copy                             # [ "Configuration Data", "Configuration Data" ]
  peek logValue                    # Stack remains unchanged
  drop                             # [ "Configuration Data" ]
]
```

Algorithm:
1. Initialize an empty stack.
2. Push an initial value onto the stack.
3. Use `copy` to duplicate the top item.
4. Use `peek` to execute a side-effect (like logging) with the top item, leaving the stack untouched.
5. Use `drop` to remove the duplicated item from the stack, restoring its original state.

## Collecting the Entire Stack

This recipe demonstrates how to gather all current stack items into a single array on the stack.

Katana provides the `stack` combinator to encapsulate the entire stack into a single array, which is useful before finalizing a compositional flow.

```coffeescript
import { pipe } from "@dashkite/joy/function"
import { push, stack } from "@dashkite/katana"

collectItems = pipe [
  -> []
  push -> "First"
  push -> "Second"
  push -> "Third"
  stack           # [ [ "First", "Second", "Third" ] ]
]
```

Algorithm:
1. Initialize an empty stack.
2. Push several items onto the stack sequentially.
3. Apply `stack` to wrap all items present on the stack into a new array. The stack will now contain exactly one item: this array.
