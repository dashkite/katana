import assert from "assert"
import {wrap, curry, flow} from "panda-garden"
import {push, pop, peek, replace, append, copy, test, log} from "../src"
import colors from "colors/safe"

add = curry (x, y) -> x + y

do ->

  machine = flow [
    push add 3
    copy
    push add
    pop (x) -> assert.equal x, 6
    peek (x, y) -> assert.equal x, y
    replace add
    pop (x, y) -> assert.equal x, 6
  ]

  try
    assert.equal (await machine [ 0 ]).length, 0
    console.log colors.green "Simple Composition"
  catch error
    console.log colors.red "Simple Composition"
    console.error error

do ->

  machine = test ((program) -> program == "A"), flow [
    push wrap 3
    copy
    push add
  ]

  try
    assert.equal (await machine [ "A" ])[0], 6
    assert.equal (await machine [ "B" ])[0], "B"
    console.log colors.green "Predicate"
  catch error
    console.log colors.red "Predicate"
    console.error error
