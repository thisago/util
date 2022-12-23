import std/unittest
from std/random import randomize
randomize()

import util/forId

suite "For FS":
  test "genCpfVerificationDigits":
    check [1, 1, 1, 4, 4, 4, 7, 7, 7].genCpfVerificationDigits == [3, 5]
  test "genCpf":
    check genCpf(formatted = true).len == 14
    check genCpf(formatted = false).len == 11
  test "parseCpf":
    let parsed = "111.444.777-35".parseCpf
    check parsed.code == [1, 1, 1, 4, 4, 4, 7, 7, 7]
    check parsed.verification == [3, 5]
  test "validCpf":
    check validCpf "111.444.777-35"
    check not validCpf "111.444.777-99"
    
  test "genCnpjVerificationDigits":
    check [1, 1, 2, 2, 2, 3, 3, 3, 0, 0, 0, 1].genCnpjVerificationDigits == [8, 1]
  test "genCnpj":
    check genCnpj(formatted = true).len == 18
    check genCnpj(formatted = false).len == 14
  test "parseCnpj":
    let parsed = "11.222.333/0001-81".parseCnpj
    check parsed.code == [1, 1, 2, 2, 2, 3, 3, 3, 0, 0, 0, 1] 
    check parsed.verification == [8, 1]
  test "validCnpj":
    check validCnpj "11.222.333/0001-81"
    check not validCnpj "11.222.333/0001-99"
    
