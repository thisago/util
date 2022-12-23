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
    check parsed.firstDigits == [1, 1, 1, 4, 4, 4, 7, 7, 7]
    check parsed.verification == [3, 5]

  test "validCpf":
    check validCpf "111.444.777-35"
    check not validCpf "111.444.777-99"
