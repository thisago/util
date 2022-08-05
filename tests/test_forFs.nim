import std/unittest

import util/forFs

suite "For FS":
  test "safeName":
    check "10/2: ?".escapeFs == "10-2- -"
