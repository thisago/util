import std/unittest
from std/times import fromUnix, utc

import util/forTime

suite "For time":
  test "nowUnix":
    check nowUnix() > 1669113763
  test "toUnix":
    check fromUnix(1669113763).utc.toUnix == 1669113763
  test "setMidnight":
    check fromUnix(946684999).utc.setMidnight.toUnix == 946684800
  test "nextBirthday":
    check fromUnix(946684800).utc.nextBirthday(fromUnix(1671494400).utc).toUnix == 1672531200
  test "lastBirthday":
    check fromUnix(946684800).utc.lastBirthday(fromUnix(1671494400).utc).toUnix == 1640995200
  test "yearsOld":
    check fromUnix(946684800).utc.yearsOld(fromUnix(1671494400).utc) == 22
  test "decimalYearsOld":
    # WHY IT CHANGED FROM `22.96712328767123` to `21.96712328767123`?
    check fromUnix(946684800).utc.decimalYearsOld(fromUnix(1671494400).utc) == 21.96712328767123
