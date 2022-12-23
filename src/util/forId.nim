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
    code: array[9, int]
    verification: array[2, int]

const newParsedCpf = (false,[-1,-1,-1,-1,-1,-1,-1,-1,-1],[-1,-1])

func parseCpf*(cpf: string): ParsedCpf =
  ## Strip and parses the cpf
  runnableExamples:
    let parsed = "111.444.777-35".parseCpf
    doAssert parsed.code == [1, 1, 1, 4, 4, 4, 7, 7, 7]
    doAssert parsed.verification == [3, 5]
  result = newParsedCpf
  template add(res: var ParsedCpf; ch: char) =
    let x = parseInt $ch
    var i = 0
    while (i < 9 and res.code[i] != -1): inc i
    if i < 9:
      res.code[i] = x
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
  let (valid, code, verification) = parseCpf cpf
  if not valid:
    return false
  let d = code.genCpfVerificationDigits
  result = verification == d


# CNPJ

func genCnpjVerificationDigits*(digits: openArray[int]): array[2, int] =
  ## Generates the CNPJ verification  code
  runnableExamples:
    from std/random import randomize
    randomize()
    doAssert [2, 4, 3, 8, 2, 7, 5, 3, 0, 0, 0, 1].genCnpjVerificationDigits == [7, 7]
  func sumMultiplied(arr: openArray[int]; firstDigit = -1): int =
    result = 0
    var i = 5
    if firstDigit >= 0:
      result = firstDigit * 2
      inc i
    for o, x in arr:
      if i < 2:
        i = 9
      result.inc x * i
      dec i
    result = 11 - (result mod 11)
    if result >= 10: result = 0
  if digits.len == 12:
    result[0] = digits.sumMultiplied
    result[1] = digits.sumMultiplied result[0]

type
  ParsedCnpj* = tuple
    valid: bool
    code: array[12, int]
    verification: array[2, int]

const newParsedCnpj = (false,[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],[-1,-1])

func parseCnpj*(cpf: string): ParsedCnpj =
  ## Strip and parses the CNPJ
  runnableExamples:
    let parsed = "11.222.333/0001-81".parseCnpj
    doAssert parsed.code == [1,1,2,2,2,3,3,3,0,0,0,1]
    doAssert parsed.verification == [8,1]
  result = newParsedCnpj
  template add(res: var ParsedCnpj; ch: char) =
    let x = parseInt $ch
    var i = 0
    while (i < 12 and res.code[i] != -1): inc i
    if i < 12:
      res.code[i] = x
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

proc genCnpj*(formatted = true; valid = true): string =
  ## Brazil CNPJ generator  
  ## Based in https://www.macoratti.net/alg_cnpj.htm
  runnableExamples:
    from std/random import randomize
    randomize()
    doAssert genCnpj(formatted = true).len == 18
    doAssert genCnpj(formatted = false).len == 14
  var n = randSeq(8, 9)
  n.add 0
  n.add 0
  n.add 0
  n.add 1
  let randomDigit = randSeq(2, 9)
  var d = [randomDigit[0], randomDigit[1]]
  if valid:
    d = n.genCnpjVerificationDigits
  result = fmt"{n[0]}{n[1]}.{n[2]}{n[3]}{n[4]}.{n[5]}{n[6]}{n[7]}/{n[8]}{n[9]}{n[10]}{n[11]}-{d[0]}{d[1]}"
  if not formatted:
    result = result.multiReplace {".": "", "-": "", "/": ""}

proc validCnpj*(cpf: string): bool =
  ## Checks if the given CNPJ is valid
  runnableExamples:
    from std/random import randomize
    randomize()
    doAssert validCnpj "11.222.333/0001-81"
    doAssert not validCnpj "11.222.333/0001-99"
  result = false
  let (valid, code, verification) = parseCnpj cpf
  if not valid:
    return false
  let d = code.genCnpjVerificationDigits
  result = verification == d


when isMainModule:
  from std/random import randomize
  randomize()
  echo genCnpj(true)
  echo genCnpj(valid = false).parseCnpj
  echo genCnpj(valid = false).validCnpj
  echo [2, 4, 3, 8, 2, 7, 5, 3, 0, 0, 0, 1].genCnpjVerificationDigits
  echo parseCnpj "24.382.753/0001-77"
