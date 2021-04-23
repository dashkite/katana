import {print, test, success} from "amen"

do ->

  print await test "Katana", [

    (await import("./async")).default
    (await import("./sync")).default

  ]

  process.exit if success then 0 else 1
