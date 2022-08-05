## Utilities `forRand`om data generation
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
