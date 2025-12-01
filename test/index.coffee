import assert from "@dashkite/assert"
import { test, success } from "@dashkite/amen"
import print from "@dashkite/amen-console"

import { pipe } from "@dashkite/joy/function"

import {
  push
  pop
  peek
  poke
  replace
  drop
  discard
  up
  down
  swap
  copy
  duplicate
  flatten
  stack  
} from "../src"

do ->

  print await test "Katana", [

    test "push", [

      test "sync", ->
        assert.deepEqual [ 1..6 ], 
          do pipe [
            -> [ 1..5 ] 
            push -> 6
          ]
      
      test "async", ->
        assert.deepEqual [ 1..6 ], 
          await do pipe [
            -> [ 1..5 ] 
            push -> Promise.resolve 6
          ]

    ]
    
    test "pop", [

      test "sync", ->
        assert.deepEqual [ 1..4 ], 
          do pipe [
            -> [ 1..5 ] 
            pop ( x ) -> true
          ]

      test "async", ->
        assert.deepEqual [ 1..4 ], 
          await do pipe [
            -> [ 1..5 ] 
            pop ( x ) -> Promise.resolve true
          ]

    ]
    
    test "peek", [

      test "sync", ->
        assert.deepEqual [ 1..5 ], 
          do pipe [
            -> [ 1..5 ] 
            peek ( x ) -> true
          ]

      test "async", ->
        assert.deepEqual [ 1..5 ], 
          await do pipe [
            -> [ 1..5 ] 
            peek ( x ) -> Promise.resolve true
          ]

    ]
    
    test "poke", [

      test "sync", ->
        assert.deepEqual [ 1, 2, 3, 4, 6 ], 
          do pipe [
            -> [ 1..5 ] 
            poke ( x ) -> x + 1
          ]

      test "async", ->
        assert.deepEqual [ 1, 2, 3, 4, 6 ], 
          await do pipe [
            -> [ 1..5 ] 
            poke ( x ) -> Promise.resolve x + 1
          ]

    ]
    
    test "drop", ->
      assert.deepEqual [ 1..4 ],
        do pipe [
          -> [ 1..5 ] 
          drop
        ]
    
    test "up", ->
      assert.deepEqual [ 5, 1, 2, 3, 4 ],
        do pipe [
          -> [ 1..5 ] 
          up
        ]
    
    test "down", ->
      assert.deepEqual [ 2, 3, 4, 5, 1 ],
        do pipe [
          -> [ 1..5 ] 
          down
        ]
    
    test "swap", ->
      assert.deepEqual [ 1, 2, 3, 5, 4 ],
        do pipe [
          -> [ 1..5 ] 
          swap
        ]
    
    test "copy", ->
      assert.deepEqual [ 1, 2, 3, 4, 5, 5 ],
        do pipe [
          -> [ 1..5 ] 
          copy
        ]
    
    test "flatten", ->
      assert.deepEqual [ 5..1 ],
        do pipe [
          -> [[ 1..5 ]]
          flatten
        ]

    
    test "stack", ->
      assert.deepEqual [[ 1, 2, 3, 4, 5 ]],
        do pipe [
          -> [ 1..5 ] 
          stack
        ]

    test "iterable", ->
      f = -> yield x for x in [1..5]
      do pipe [
        f
        peek ( x ) -> assert.equal 5, x
      ]

    test "async composition", ->
      await do pipe [
        -> [ 1..5 ]
        push ( x ) -> Promise.resolve x + 1
        peek ( x ) -> assert.equal 6, x
      ]

    test "auto initialization", ->
      do pipe [
        push -> 1
        push -> 2
        poke ( x, y ) -> x + y
        peek ( x ) -> assert.equal 3, x
      ]




  ]

  
