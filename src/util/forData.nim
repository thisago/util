## Utilities `forData` manipulation and analysis
# from std/tables import Table, `[]`, `[]=`, hasKey, pairs
import std/tables

proc occurrences*[T](xs: openArray[T]): Table[T, int] =
  ## Get all occurrences of values in array
  runnableExamples:
    import std/tables
    doAssert occurrences(["a", "b", "c", "a"]) == {"a": 2, "b": 1, "c": 1}.toTable
    doAssert occurrences(["a", "b", "c", "c"]) == {"a": 1, "b": 1, "c": 2}.toTable
    doAssert occurrences(["a", "a", "b", "c", "c"]) == {"a": 2, "b": 1, "c": 2}.toTable
  for x in xs:
    result[x] =
      if result.hasKey x:
        result[x] + 1
      else:
        1

proc occurrence*[T](xs: openArray[T], val: T): int =
  ## Get the occurrence of specific value in array
  runnableExamples:
    import std/tables
    doAssert(["a", "b", "c", "a"].occurrence("b") == 1)
    doAssert(["a", "b", "c", "c"].occurrence("e") == 0)
    doAssert(["a", "a", "b", "c", "c"].occurrence("c") == 2)
  let xsOccurrences = xs.occurrences
  if xsOccurrences.hasKey val:
    result = xsOccurrences[val]

proc mostCommon*[T](xs: openArray[T]): seq[T] =
  ## Get the most common values at array
  runnableExamples:
    import std/tables
    doAssert mostCommon(["a", "b", "c", "a"]) == ["a"]
    doAssert mostCommon(["a", "b", "c", "c"]) == ["c"]
    doAssert mostCommon(["a", "a", "b", "c", "c"]) == ["c", "a"]
  let xsOccurrences = xs.occurrences
  var maxOccurrence = 0
  for val, occurrence in xsOccurrences:
    if occurrence > maxOccurrence:
      maxOccurrence = occurrence  
  for val, occurrence in xsOccurrences:
    if occurrence >= maxOccurrence:
      result.add val

# Random

from std/random import sample
from std/strutils import Digits, Letters

proc randStr*(len: int; chars = Digits + Letters): string =
  ## Generate a random string using given chars
  ## 
  ## Need call `randomize` before
  runnableExamples:
    from std/random import randomize
    randomize()
    doAssert randStr(10).len == 10
  while result.len < len:
    result.add sample chars
