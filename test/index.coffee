import assert from "assert"
import {flow, curry} from "panda-garden"
import {push, pop, peek, replace, append, copy} from "../src"
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
