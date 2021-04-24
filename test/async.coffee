import assert from "assert"
import {print, test, success} from "amen"
import * as _ from "@dashkite/joy"
import * as $ from "../src/async"
import { verify, compare } from "./helpers"

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

    test "assign", ->
      f = $.assign [
        $.push -> Promise.resolve "bar"
        $.write "foo"
      ]
      verify.stack [], await f []
      verify.context foo: "bar", await f []

  ]

  test "predicates", do ->

    promised = (x) -> Promise.resolve x

    [

      test "test", ->
        f = $.test promised, $.poke _.wrap "foo"
        verify.stack [ "foo" ], await f [ true ]
        verify.stack [ false ], await f [ false ]
        # test a truthy value: should leave stack unchanged
        verify.stack [ "bar" ], await f [ "bar" ]

      test "branch", ->
        f = $.branch [
          [ promised, $.poke _.wrap "foo" ]
          [ (_.wrap true), $.poke _.wrap "bar" ]
        ]
        verify.stack [ "foo" ], await f [ true ]
        verify.stack [ "bar" ], await f [ false ]

  ]

]

export default results
