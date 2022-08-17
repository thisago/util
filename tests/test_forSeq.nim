import std/unittest
import std/tables

import util/forSeq

suite "For seq":
  test "occurrences":
    check occurrences(["a", "b", "c", "a"]) == {"a": 2, "b": 1, "c": 1}.toTable
    check occurrences(["a", "b", "c", "c"]) == {"a": 1, "b": 1, "c": 2}.toTable
    check occurrences(["a", "a", "b", "c", "c"]) == {"a": 2, "b": 1, "c": 2}.toTable

  test "occurrence":
    check(["a", "b", "c", "a"].occurrence("b") == 1)
    check(["a", "b", "c", "c"].occurrence("e") == 0)
    check(["a", "a", "b", "c", "c"].occurrence("c") == 2)

  test "mostCommon":
    check mostCommon(["a", "b", "c", "a"]) == ["a"]
    check mostCommon(["a", "b", "c", "c"]) == ["c"]
    check mostCommon(["a", "a", "b", "c", "c"]) == ["c", "a"]
