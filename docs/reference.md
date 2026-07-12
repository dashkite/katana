# Reference

## push

$push: (f, stack) \to stack$

Call `f` with `k` items from the stack, where `k` is the arity of `f`. Push the return value onto the stack.

## pop

$pop: (f, stack) \to stack$

Call `f` with `k` items from the stack, where `k` is the arity of `f`. Pops the items from the stack.

## poke

$poke: (f, stack) \to stack$

Call `f` with `k` items from the stack, where `k` is the arity of `f`. Pops the items from the stack. Push the return value onto the stack.

## replace

$replace: (f, stack) \to stack$

Alias for `poke`. Call `f` with `k` items from the stack, where `k` is the arity of `f`. Pops the items from the stack. Push the return value onto the stack.

## peek

$peek: (f, stack) \to stack$

Call `f` with `k` items from the stack, where `k` is the arity of `f`. Leaves the stack unchanged.

## drop

$drop: (stack) \to stack$

Pops the stack. Equivalent to `pop ( x ) ->`.

## discard

$discard: (stack) \to stack$

Alias for `drop`. Pops the stack. Equivalent to `pop ( x ) ->`.

## up

$up: (stack) \to stack$

Rotates the items on the stack, pushing items up, while the top of the stack goes to the bottom.

## down

$down: (stack) \to stack$

Rotates the items on the stack, pushing items down, while the bottom of the stack goes to the top.

## swap

$swap: (stack) \to stack$

Swaps the first two items on the stack, so the first becomes the second and vice-versa.

## copy

$copy: (stack) \to stack$

Copies the top item on the stack.

## duplicate

$duplicate: (stack) \to stack$

Alias for `copy`. Copies the top item on the stack.

## flatten

$flatten: (stack) \to stack$

If the first item of the stack is an iterable, push each item it produces onto the stack. Items are added in the reverse order from when they are produced, so that the first item produced will be at the top of the stack. If it is not an iterable, do nothing.

## stack

$stack: (stack) \to stack$

Place the stack on the stack as an array, removing all the other items.
