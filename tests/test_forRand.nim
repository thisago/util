import std/unittest
from std/random import randomize

import util/forRand

randomize()


suite "For rand":
  test "randStr":
    check randStr(10).len == 10
    check randStr(1).len == 1
    check randStr(10) != randStr(10)
