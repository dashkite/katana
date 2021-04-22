import {print, test, success} from "amen"

do ->

  print await test "Katana", [

    (await import("./async")).default
    (await import("./sync")).default

  ]
