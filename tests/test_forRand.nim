import std/unittest
from std/random import randomize

import util/forRand

randomize 0

suite "For rand":
  test "randStr":
    check randStr(10) == "tpa18NzNnH"
  test "randSeq":
    check randSeq(5, 5) == @[5, 0, 2, 5, 2]
