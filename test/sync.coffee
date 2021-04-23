import assert from "assert"
import {print, test, success} from "amen"
import * as _ from "@dashkite/joy"
import * as $ from "../src/sync"
import { Daisho } from "../src/daisho"
import { verify, compare } from "./helpers"

results = test "sync", [

  test "stack operators", [

    test "push", ->
      f = $.push _.wrap 0
      verify.stack [ 0 ], f []

    test "pop", ->
      x = 0
      f = $.pop (y) -> x = y
      verify.stack [], f [ 1 ]
      assert.equal x, 1

    test "discard", ->
      verify.stack [], $.discard [ 1 ]

    test "peek", ->
      x = 0
      f = $.peek (y) -> x = y
      verify.stack [ 1 ], f [ 1 ]
      assert.equal x, 1

    test "poke", ->
      f = $.poke _.wrap 1
      verify.stack [ 1 ], f [ 0 ]

    test "pushn", ->
      incr = (x) -> ++x
      f = $.pushn [
        incr
        incr
      ]
      verify.stack [ 1, 1, 0 ], f [ 0 ]

    test "mpop", ->
      x = 0
      f = $.mpop (y, z) -> x = y + z
      verify.stack [], f [ 1, 2 ]
      assert.equal x, 3

    test "mpoke", ->
      f = $.mpoke (x, y) -> x + y
      verify.stack [ 3 ], f [ 1, 2 ]

  ]

  test "context operators", [

    test "assign", ->
      f = $.assign _.pipe [
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
      f = $.test _.identity, $.poke _.wrap "foo"
      verify.stack [ "foo" ], await f [ true ]
      verify.stack [ false ], await f [ false ]
      # test a truthy value: should leave stack unchanged
      verify.stack [ "bar" ], await f [ "bar" ]

    test "branch", ->
      f = $.branch [
        [ _.identity, $.poke _.wrap "foo" ]
        [ (_.wrap true), $.poke _.wrap "bar" ]
      ]
      verify.stack [ "foo" ], await f [ true ]
      verify.stack [ "bar" ], await f [ false ]


  ]

]

export default results
