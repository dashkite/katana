import assert from "assert"
import * as _ from "@dashkite/joy"

verify =
  stack: (expected, actual) -> assert.deepEqual expected, actual.stack
  context: (expected, actual) -> assert.deepEqual expected, actual.context

compare = _.curry (x, y) -> x == y


export {
  verify
  compare
}
