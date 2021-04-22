import assert from "assert"
import {print, test, success} from "amen"
import * as _ from "@dashkite/joy"
import * as $ from "../src/async"

compare = _.curry (x, y) -> x == y

results = test "async", [

  test "stack operators", [

    test "push", ->
      f = $.push _.wrap 0
      assert.deepEqual [ 0 ], await f []

    test "pop", ->
      x = 0
      f = $.pop -> x = 1
      assert.deepEqual [], await f [ 0 ]
      assert.equal x, 1

    test "peek", ->
      x = 0
      f = $.peek -> x = 1
      assert.deepEqual [ 0 ], await f [ 0 ]
      assert.equal x, 1

    test "poke", ->
      f = $.poke _.wrap 1
      assert.deepEqual [ 1 ], await f [ 0 ]

    test "pushn", ->
      incr = (x) -> ++x
      f = $.pushn [
        incr
        incr
      ]
      assert.deepEqual [ 1, 1, 0 ], await f [ 0 ]

    test "mpop", ->
      x = 0
      f = $.mpop (y, z) -> x = y + z
      assert.deepEqual [], await f [ 1, 2 ]
      assert.equal x, 3

    test "mpoke", ->
      f = $.mpoke (x, y) -> x + y
      assert.deepEqual [ 3 ], await f [ 1, 2 ]

    test "discard", ->
      assert.deepEqual [], $.discard [ 1 ]

  ]

  test "context operators", [

    test "read", ->
      f = $.read "foo"
      assert.deepEqual [ "bar", foo: "bar" ], f [ foo: "bar" ]

    test "write", ->
      f = $.write "foo"
      assert.deepEqual [ "bar", foo: "bar" ], f [ "bar", {} ]

    test "copy", ->
      f = $.copy _.flow [
        $.push -> "bar"
        $.write "foo"
      ]
      assert.deepEqual [ foo: "bar" ], await f [ {} ]


  ]

  test "predicates", [

    test "test", ->
      f = $.test _.identity, $.poke _.wrap 1
      assert.deepEqual [ 1 ], await f [ true ]
      assert.deepEqual [ false ], await f [ false ]
      # test a truthy value: should leave stack unchanged
      assert.deepEqual [ -1 ], await f [ -1 ]

    test "branch", ->
      f = $.branch [
        [ (compare 1), $.poke _.wrap 2 ]
        [ (compare 2), $.poke _.wrap 3 ]
        [ (_.wrap true), $.poke _.wrap 4 ]
      ]
      assert.deepEqual [ 2 ], await f [ 1 ]
      assert.deepEqual [ 3 ], await f [ 2 ]
      assert.deepEqual [ 4 ], await f [ 3 ]


  ]

]

export default results
