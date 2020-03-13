import assert from "assert"
import {print, test, success} from "amen"

import {identity, wrap, curry, flow} from "panda-garden"
import {push, pop, peek, poke,
  test as check, branch,
  mpop, mpoke,
  restore, dupe, clear,
  rack, nth, second, third,
  over,
  apply, cover, stack, spread,
  log} from "../src"
import {map, collect} from "panda-river"
all = -> Promise.all arguments...

compare = curry (x, y) -> x == y

do ->

  print await test "Katana", [

    test "core combinators", [

      test "push", ->
        f = push wrap 0
        assert.deepEqual [ 0 ], await f []

      test "pop", ->
        x = 0
        f = pop -> x = 1
        assert.deepEqual [], await f [ 0 ]
        assert.equal x, 1

      test "peek", ->
        x = 0
        f = peek -> x = 1
        assert.deepEqual [ 0 ], await f [ 0 ]
        assert.equal x, 1

      test "poke", ->
        f = poke wrap 1
        assert.deepEqual [ 1 ], await f [ 0 ]

    ]

    test "predicate combinators", [

      test "test", ->
        f = check identity, poke wrap 1
        assert.deepEqual [ 1 ], await f [ true ]
        assert.deepEqual [ false ], await f [ false ]

      test "branch", ->
        f = branch [
          [ (compare 1), poke wrap 2 ]
          [ (compare 2), poke wrap 3 ]
          poke wrap 4
        ]
        assert.deepEqual [ 2 ], await f [ 1 ]
        assert.deepEqual [ 3 ], await f [ 2 ]
        assert.deepEqual [ 4 ], await f [ 3 ]

    ]

    test "arity combinators", [

      test "mpop", ->
        x = 0
        f = mpop (y, z) -> x = y + z
        assert.deepEqual [], await f [ 1, 2 ]
        assert.equal x, 3

      test "mpoke", ->
        f = mpoke (x, y) -> x + y
        assert.deepEqual [ 3 ], await f [ 1, 2 ]

    ]

    test "stack mutators", [

      test "restore", ->
        f = restore poke wrap 1
        assert.deepEqual [ 0 ], await f [ 0 ]

      test "dupe", ->
        assert.deepEqual [ 0, 0 ], dupe [ 0 ]

      test "clear", ->
        assert.equal 0, (clear [ 0 ]).length

    ]

    test "stack adapters", [

      test "rack", ->
        x = 0
        reverse = (stack) -> stack.reverse()
        f = rack reverse, peek (y) -> x = y
        f [1..3]
        assert.equal x, 3

      test "nth, second, third", ->
        x = 0
        f = third peek (y) -> x = y
        f [4..6]
        assert.equal x, 6

    ]

    test "stack iteration", [

      test "over", ->
        multiply = (x, y) -> x * y
        f = over map mpoke multiply
        assert.deepEqual (await collect f [ [1..5], 2 ]),
          [ [ 2 ], [ 4 ], [ 6 ], [ 8 ], [ 10 ] ]

    ]

    test "convenience combinators", [

      test "apply", ->
        assert.equal true, apply identity, [ true ]

      test "cover", ->
        f = (x, y) -> x + y
        assert.equal 3, cover f, [1..5]

      test "stack", ->
        f = stack ([x, y]) -> x + y
        assert.equal 3, f 1, 2

      test "spread", ->
        f = spread (x, y) -> x + y
        assert.equal 3, (f [1, 2])
    ]

  ]
