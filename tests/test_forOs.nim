import std/unittest
from std/os import putEnv

import util/forOs

suite "For OS":
  test "getEnv":
    putEnv("name", "Joe")
    check getEnv("name") == "Joe"
