import assert from "assert"
import {print, test, success} from "amen"
import * as _ from "@dashkite/joy"
import * as $ from "../src/sync"
import { Daisho } from "../src/daisho"

verify = (expected, actual) ->
  assert.deepEqual expected, actual._stack

verify.stack = (expected, actual) ->
  assert.deepEqual expected, actual._stack

verify.context = (expected, actual) ->
  assert.deepEqual expected, actual._context

compare = _.curry (x, y) -> x == y

results = test "sync", [

  test "stack operators", [

    test "push", ->
      f = $.push _.wrap 0
      verify [ 0 ], f []

    test "pop", ->
      x = 0
      f = $.pop (y) -> x = y
      verify [], f [ 1 ]
      assert.equal x, 1

    test "discard", ->
      verify.stack [], $.discard [ 1 ]

    test "peek", ->
      x = 0
      f = $.peek (y) -> x = y
      verify [ 1 ], f [ 1 ]
      assert.equal x, 1

    test "poke", ->
      f = $.poke _.wrap 1
      verify [ 1 ], f [ 0 ]

    test "pushn", ->
      incr = (x) -> ++x
      f = $.pushn [
        incr
        incr
      ]
      verify [ 1, 1, 0 ], f [ 0 ]

    test "mpop", ->
      x = 0
      f = $.mpop (y, z) -> x = y + z
      verify [], f [ 1, 2 ]
      assert.equal x, 3

    test "mpoke", ->
      f = $.mpoke (x, y) -> x + y
      verify [ 3 ], f [ 1, 2 ]

  ]

  test "context operators", [

    test "copy", ->
      f = $.copy _.pipe [
        $.push -> "bar"
        $.write "foo"
      ]
      verify.stack [], f []
      verify.context foo: "bar", f []

    test "read", ->
      f = $.read "foo"
      verify.stack [ "bar" ], f Daisho.create [], foo: "bar"

    test "write", ->
      f = $.write "foo"
      verify.context foo: "bar", f [ "bar" ]

    test "context", ->
      f = $.context
      verify.stack [ foo: "bar" ], f Daisho.create [], foo: "bar"

  ]

  test "predicates", [

    test "test", ->
      f = $.test _.identity, $.poke _.wrap 1
      verify [ 1 ], f [ true ]
      verify [ false ], f [ false ]
      # test a truthy value: should leave stack unchanged
      verify [ -1 ], f [ -1 ]

    test "branch", ->
      f = $.branch [
        [ (compare 1), $.poke _.wrap 2 ]
        [ (compare 2), $.poke _.wrap 3 ]
        [ (_.wrap true), $.poke _.wrap 4 ]
      ]
      verify [ 2 ], f [ 1 ]
      verify [ 3 ], f [ 2 ]
      verify [ 4 ], f [ 3 ]


  ]

]

export default results
