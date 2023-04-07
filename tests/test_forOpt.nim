import std/unittest
from std/options import some, none

import util/forOpt

suite "For time":
  test "tryGet":
    check some("hi").tryGet("bye") == "hi"
    check none(string).tryGet("bye") == "bye"
