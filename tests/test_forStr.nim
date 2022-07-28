import std/unittest
import util/forStr

suite "For string":
  test "between":
    check "The dog is lazy".between("dog", "lazy") == " is "
    check "The dog is lazy".between("dog", "lazy", catchAll = true) == "dog is lazy"
