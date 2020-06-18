import assert from "assert"
import {print, test, success} from "amen"

import {identity, wrap, curry, flow} from "@pandastrike/garden"
import {apply, stack, spread,
  push, pop, peek, poke, pushn
  read, write, discard
  mpop, mpoke
  test as atest, branch,
  spush, spop, speek, spoke, spushn
  stest, sbranch,
  smpop, smpoke,
  over,
  log
  } from "../src"

import {map, collect} from "panda-river"
all = -> Promise.all arguments...

compare = curry (x, y) -> x == y

do ->

  print await test "Katana", [

    test "core", [

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

      test "pushn", ->
        incr = (x) -> ++x
        f = pushn [
          incr
          incr
        ]
        assert.deepEqual [ 1, 1, 0 ], await f [ 0 ]

      test "read", ->
        f = read "foo"
        assert.deepEqual [ "bar", foo: "bar" ], f [ foo: "bar" ]

      test "write", ->
        f = write "foo"
        assert.deepEqual [ "bar", foo: "bar" ], f [ "bar", {} ]

      test "discard", ->
        assert.deepEqual [], discard [ 1 ]

      test "spush", ->
        f = spush wrap 0
        assert.deepEqual [ 0 ], f []

      test "spop", ->
        x = 0
        f = spop -> x = 1
        assert.deepEqual [], f [ 0 ]
        assert.equal x, 1

      test "speek", ->
        x = 0
        f = speek -> x = 1
        assert.deepEqual [ 0 ], f [ 0 ]
        assert.equal x, 1

      test "spoke", ->
        f = spoke wrap 1
        assert.deepEqual [ 1 ], f [ 0 ]

      test "spushn", ->
        incr = (x) -> ++x
        f = spushn [
          incr
          incr
        ]
        assert.deepEqual [ 1, 1, 0 ], await f [ 0 ]

    ]

    test "predicates", [

      test "test", ->
        f = atest identity, poke wrap 1
        assert.deepEqual [ 1 ], await f [ true ]
        assert.deepEqual [ false ], await f [ false ]
        # test a truthy value: should leave stack unchanged
        assert.deepEqual [ -1 ], await f [ -1 ]

      test "branch", ->
        f = branch [
          [ (compare 1), poke wrap 2 ]
          [ (compare 2), poke wrap 3 ]
          [ (wrap true), poke wrap 4 ]
        ]
        assert.deepEqual [ 2 ], await f [ 1 ]
        assert.deepEqual [ 3 ], await f [ 2 ]
        assert.deepEqual [ 4 ], await f [ 3 ]

      test "stest", ->
        f = stest identity, spoke wrap 1
        assert.deepEqual [ 1 ], f [ true ]
        assert.deepEqual [ false ], f [ false ]
        # test a truthy value: should leave stack unchanged
        assert.deepEqual [ -1 ], f [ -1 ]

      test "sbranch", ->
        f = sbranch [
          [ (compare 1), spoke wrap 2 ]
          [ (compare 2), spoke wrap 3 ]
          [ (wrap true), spoke wrap 4 ]
        ]
        assert.deepEqual [ 2 ], f [ 1 ]
        assert.deepEqual [ 3 ], f [ 2 ]
        assert.deepEqual [ 4 ], f [ 3 ]

    ]

    test "arity", [

      test "mpop", ->
        x = 0
        f = mpop (y, z) -> x = y + z
        assert.deepEqual [], await f [ 1, 2 ]
        assert.equal x, 3

      test "mpoke", ->
        f = mpoke (x, y) -> x + y
        assert.deepEqual [ 3 ], await f [ 1, 2 ]

      test "mpop", ->
        x = 0
        f = smpop (y, z) -> x = y + z
        assert.deepEqual [], f [ 1, 2 ]
        assert.equal x, 3

      test "mpoke", ->
        f = smpoke (x, y) -> x + y
        assert.deepEqual [ 3 ], f [ 1, 2 ]

    ]

    test "iteration", [

      test "over", ->
        {min} = Math
        multiply = (x, y) -> x * y
        f = over map mpoke multiply
        assert.deepEqual (await collect f [ [1..5], 2 ]),
          [ [ 2 ], [ 4 ], [ 6 ], [ 8 ], [ 10 ] ]

    ]

    test "convenience", [

      test "apply", ->
        f = (x, y) -> x + y
        assert.equal 3, apply f, [1..5]

      test "stack", ->
        f = stack ([x, y]) -> x + y
        assert.equal 3, f 1, 2

      test "spread", ->
        f = spread (x, y) -> x + y
        assert.equal 3, (f [1, 2])

    ]

  ]
