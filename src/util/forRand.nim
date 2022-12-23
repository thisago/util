## Utilities `forRand`om data generation
from std/random import sample, rand
from std/strutils import Digits, Letters
from std/sequtils import toSeq

proc randStr*(len: int; chars = Digits + Letters): string =
  ## Generate a random string using given chars
  ## 
  ## Need call `randomize` before
  runnableExamples:
    from std/random import randomize
    randomize 0
    doAssert randStr(10) == "tpa18NzNnH"
  while result.len < len:
    result.add sample chars

proc randSeq*(len, max: int; min = 0): seq[int] =
  ## Generates an array with the provided `len` with the random
  ## numbers less or equals than `max`
  runnableExamples:
    from std/random import randomize
    randomize 0
    doAssert randSeq(5, 5) == @[1, 1, 2, 3, 0]
  result = toSeq 1..len
  for val in result.mitems:
    val = rand min..max
