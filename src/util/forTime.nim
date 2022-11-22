# Utilities `forTime` handling

from std/times import getTime, toUnix, DateTime, year, now, `year=`, `hour=`,
                      `minute=`, `second=`, toTime, toUnix

proc nowUnix*: int64 {.inline.} =
  ## Returns the unix time of now
  runnableExamples:
    doAssert nowUnix() > 1669113763
  getTime().toUnix

proc toUnix*(date: DateTime): int64 {.inline.} =
  ## Returns the unix time of provided date
  runnableExamples:
    from std/times import fromUnix
    doAssert fromUnix(1669113763).toUnix == 1669113763
  date.toTime.toUnix

proc setMidnight*(date: DateTime): DateTime =
  ## Calculates the next birthday date
  ## 
  ## Based in https://github.com/rubenwardy/renewedtab/blob/35d0afb8cdf5a3b701e60b137ff1db7110dcc385/src/app/utils/dates.tsx#L7
  runnableExamples:
    from std/times import fromUnix, utc
    doAssert fromUnix(946684999).utc.setMidnight.toUnix == 946684800
  result = date
  result.hour = 0
  result.minute = 0
  result.second = 0
  
proc nextBirthday*(birth: DateTime; at = now()): DateTime =
  ## Calculates the next birthday date
  ## 
  ## Based in https://github.com/rubenwardy/renewedtab/blob/35d0afb8cdf5a3b701e60b137ff1db7110dcc385/src/app/utils/dates.tsx#L21
  runnableExamples:
    from std/times import fromUnix, utc
    doAssert fromUnix(946684800).utc.nextBirthday(fromUnix(1671494400).utc).toUnix == 1672531200
  result = birth
  result.year = at.year
  if result.toUnix <= at.toUnix:
    result.year = result.year + 1
  result = result.setMidnight

proc lastBirthday*(birth: DateTime; at = now()): DateTime =
  ## Calculates the next birthday date
  ## 
  ## Based in https://github.com/rubenwardy/renewedtab/blob/35d0afb8cdf5a3b701e60b137ff1db7110dcc385/src/app/utils/dates.tsx#L21
  runnableExamples:
    from std/times import fromUnix, utc
    doAssert fromUnix(946684800).utc.lastBirthday(fromUnix(1671494400).utc).toUnix == 1640995200
  result = birth
  result.year = at.year
  if result.toTime.toUnix >= at.toTime.toUnix:
    result.year = result.year - 1
  result = result.setMidnight

proc yearsOld*(birth: DateTime; at = now()): int {.inline.} =
  ## Calculates the age based on `birth`
  ## 
  ## Based in https://stackoverflow.com/a/4076440
  runnableExamples:
    from std/times import fromUnix, utc
    doAssert fromUnix(946684800).utc.yearsOld(fromUnix(1671494400).utc) == 22
  result = at.year - birth.year

proc decimalYearsOld*(birth: DateTime; at = now()): float =
  ## Calculates the age with decimal precision
  ## 
  ## Based in https://github.com/rubenwardy/renewedtab/blob/35d0afb8cdf5a3b701e60b137ff1db7110dcc385/src/app/utils/dates.tsx#L39
  runnableExamples:
    from std/times import fromUnix, utc
    doAssert fromUnix(946684800).utc.decimalYearsOld(fromUnix(1671494400).utc) == 22.96712328767123
  result = float birth.yearsOld at
  let
    lastBirth = birth.lastBirthday.toUnix
    nextBirth = birth.nextBirthday.toUnix
    atUnix = at.toUnix
  result += (atUnix - lastBirth).int / (nextBirth - lastBirth).int
