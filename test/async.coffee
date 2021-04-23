import assert from "assert"
import {print, test, success} from "amen"
import * as _ from "@dashkite/joy"
import * as $ from "../src/async"

compare = _.curry (x, y) -> x == y

verify = (expected, actual) ->
  assert.deepEqual expected, actual._stack

verify.stack = (expected, actual) ->
  assert.deepEqual expected, actual._stack

verify.context = (expected, actual) ->
  assert.deepEqual expected, actual._context

results = test "async", [

  test "stack operators", [

    test "push", ->
      f = $.push _.wrap 0
      verify.stack [ 0 ], await f []

    test "pop", ->
      x = 0
      f = $.pop -> x = 1
      verify.stack [], await f [ 0 ]
      assert.equal x, 1

    test "peek", ->
      x = 0
      f = $.peek -> x = 1
      verify.stack [ 0 ], await f [ 0 ]
      assert.equal x, 1

    test "poke", ->
      f = $.poke _.wrap 1
      verify.stack [ 1 ], await f [ 0 ]

    test "pushn", ->
      incr = (x) -> ++x
      f = $.pushn [
        incr
        incr
      ]
      verify.stack [ 1, 1, 0 ], await f [ 0 ]

    test "mpop", ->
      x = 0
      f = $.mpop (y, z) -> x = y + z
      verify.stack [], await f [ 1, 2 ]
      assert.equal x, 3

    test "mpoke", ->
      f = $.mpoke (x, y) -> x + y
      verify.stack [ 3 ], await f [ 1, 2 ]

  ]

  test "context operators", [

    test "copy", ->
      f = $.copy _.flow [
        $.push -> "bar"
        $.write "foo"
      ]
      verify.stack [], await f []
      verify.context foo: "bar", await f []

  ]

  test "predicates", [

    test "test", ->
      f = $.test _.identity, $.poke _.wrap 1
      verify.stack [ 1 ], await f [ true ]
      verify.stack [ false ], await f [ false ]
      # test a truthy value: should leave stack unchanged
      verify.stack [ -1 ], await f [ -1 ]

    test "branch", ->
      f = $.branch [
        [ (compare 1), $.poke _.wrap 2 ]
        [ (compare 2), $.poke _.wrap 3 ]
        [ (_.wrap true), $.poke _.wrap 4 ]
      ]
      verify.stack [ 2 ], await f [ 1 ]
      verify.stack [ 3 ], await f [ 2 ]
      verify.stack [ 4 ], await f [ 3 ]


  ]

]

export default results
