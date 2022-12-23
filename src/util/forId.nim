## ID generation utilities
from std/random import rand
from std/strformat import fmt
from std/strutils import multiReplace, Digits, parseInt

from ./forRand import randSeq

func genCpfVerificationDigits*(digits: openArray[int]): array[2, int] =
  ## Generates the CPF verification  code
  runnableExamples:
    from std/random import randomize
    randomize()
    doAssert [1, 1, 1, 4, 4, 4, 7, 7, 7].genCpfVerificationDigits == [3, 5]
  func sumMultiplied(arr: openArray[int]; firstDigit = -1): int =
    result = 0
    var i = 10
    if firstDigit >= 0:
      result = firstDigit * 2
      inc i
    for x in arr:
      result.inc x * i
      dec i
    result = 11 - (result mod 11)
    if result >= 10: result = 0
  if digits.len == 9:
    result[0] = digits.sumMultiplied
    result[1] = digits.sumMultiplied result[0]

proc genCpf*(formatted = true; valid = true): string =
  ## Brazil CPF generator  
  ## Based in https://www.macoratti.net/alg_cpf.htm
  runnableExamples:
    from std/random import randomize
    randomize()
    doAssert genCpf(formatted = true).len == 14
    doAssert genCpf(formatted = false).len == 11
  let
    n = randSeq(9, 9)
    randomDigit = randSeq(2, 9)
  var d = [randomDigit[0], randomDigit[1]]
  if valid:
    d = n.genCpfVerificationDigits
  result = fmt"{n[0]}{n[1]}{n[2]}.{n[3]}{n[4]}{n[5]}.{n[6]}{n[7]}{n[8]}-{d[0]}{d[1]}"
  if not formatted:
    result = result.multiReplace {".": "", "-": ""}

type
  ParsedCpf* = tuple
    valid: bool
    firstDigits: array[9, int]
    verification: array[2, int]

const newParsedCpf = (false,[-1,-1,-1,-1,-1,-1,-1,-1,-1],[-1,-1])

func parseCpf*(cpf: string): ParsedCpf =
  ## Strip and parses the cpf
  runnableExamples:
    let parsed = "111.444.777-35".parseCpf
    doAssert parsed.firstDigits == [1, 1, 1, 4, 4, 4, 7, 7, 7]
    doAssert parsed.verification == [3, 5]
  result = newParsedCpf
  template add(res: var ParsedCpf; ch: char) =
    let x = parseInt $ch
    var i = 0
    while (i < 9 and res.firstDigits[i] != -1): inc i
    if i < 9:
      res.firstDigits[i] = x
    else:
      i = 0
      while (i < 2 and res.verification[i] != -1): inc i
      if i < 2:
        result.verification[i] = x
        if i == 1:
          result.valid = true
      else:
        result.valid = false
  for x in cpf:
    if x in Digits:
      result.add x
  
proc validCpf*(cpf: string): bool =
  ## Checks if the given CPF is valid
  runnableExamples:
    from std/random import randomize
    randomize()
    doAssert validCpf "111.444.777-35"
    doAssert not validCpf "111.444.777-99"
  result = false
  let (valid, firstDigits, verification) = parseCpf cpf
  if not valid:
    return false
  let d = firstDigits.genCpfVerificationDigits

  result = verification == d
  
when isMainModule:
  from std/random import randomize
  randomize()
  doAssert genCpf(valid = false).validCpf == false
  doAssert genCpf(valid = true).validCpf == true
  doAssert genCpf(false, valid = false).validCpf == false
  doAssert genCpf(false, valid = true).validCpf == true
