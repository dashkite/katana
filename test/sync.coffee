import assert from "assert"
import {print, test, success} from "amen"
import * as _ from "@dashkite/joy"
import * as $ from "../src/sync"

compare = _.curry (x, y) -> x == y

results = test "sync", [

  test "stack operators", [

    test "push", ->
      f = $.push _.wrap 0
      assert.deepEqual [ 0 ], f []

    test "pop", ->
      x = 0
      f = $.pop -> x = 1
      assert.deepEqual [], f [ 0 ]
      assert.equal x, 1

    test "peek", ->
      x = 0
      f = $.peek -> x = 1
      assert.deepEqual [ 0 ], f [ 0 ]
      assert.equal x, 1

    test "poke", ->
      f = $.poke _.wrap 1
      assert.deepEqual [ 1 ], f [ 0 ]

    test "pushn", ->
      incr = (x) -> ++x
      f = $.pushn [
        incr
        incr
      ]
      assert.deepEqual [ 1, 1, 0 ], f [ 0 ]

    test "mpop", ->
      x = 0
      f = $.mpop (y, z) -> x = y + z
      assert.deepEqual [], f [ 1, 2 ]
      assert.equal x, 3

    test "mpoke", ->
      f = $.mpoke (x, y) -> x + y
      assert.deepEqual [ 3 ], f [ 1, 2 ]


  ]

  test "context operators", [

    test "copy", ->
      f = $.copy _.pipe [
        $.push -> "bar"
        $.write "foo"
      ]
      assert.deepEqual [ foo: "bar" ], f [ {} ]

  ]

  test "predicates", [

    test "test", ->
      f = $.test _.identity, $.poke _.wrap 1
      assert.deepEqual [ 1 ], f [ true ]
      assert.deepEqual [ false ], f [ false ]
      # test a truthy value: should leave stack unchanged
      assert.deepEqual [ -1 ], f [ -1 ]

    test "branch", ->
      f = $.branch [
        [ (compare 1), $.poke _.wrap 2 ]
        [ (compare 2), $.poke _.wrap 3 ]
        [ (_.wrap true), $.poke _.wrap 4 ]
      ]
      assert.deepEqual [ 2 ], f [ 1 ]
      assert.deepEqual [ 3 ], f [ 2 ]
      assert.deepEqual [ 4 ], f [ 3 ]


  ]

]

export default results
