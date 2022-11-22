# util

Small utilities that isn't large enough to have a individual modules

## _forHtml_ module

### `func genclass(classes: openArray[(string, bool)]): string`

Returns as string just the classes that are on

**Example**

```nim
doAssert genClass({
  "btn",
  "btn-info": true,
  "hidden": false
}) == "btn btn-info"
```

---

## _forStr_ module

### `func between(text, start, finish: string; default = ""; catchAll = false): string`

Get the text between two strings

If `justMiddle` is true, just the middle text will be returned, the searched text will be removed

**Example**

```nim
doAssert "The dog is lazy".between("dog", "lazy") == " is "
doAssert "The dog is lazy".between("dog", "lazy", catchAll = true) == "dog is lazy"
```

### `func setBetween*(text, start, finish, inside: string; default = text; replaceAll = false): string`
Set the text between two strings

If text not found, the text will be the default

If `replaceAll` is true, it will replace the text used to find too

**Example**
```nim
doAssert "I want to eat a large pineapple".setBetween("a ", " pine", "small") == "I want to eat a small pineapple"
doAssert "I want to eat a large pineapple".setBetween("a ", " pine", "small ", replaceAll = true) == "I want to eat small apple"
```

### `func stopAt*(s, stop: string or char): string`

Removes all text after `stop` (and the `stop` text too)

**Example**

```nim
doAssert "Hello World! My name is John".stopAt('!') == "Hello World"
```

### `proc parseStr*(text: string; parsers: varargs[VarParser]): string`

Parse variables using custom config

```nim
from std/sugar import `=>`
from std/tables import toTable, `[]`
let
  text = "My name is {name} and I am {age} old; My friend (name) is (age) old.\l" &
    "My favorite food is called **name**, and I've had it in my **where** for **age** now"
  me = {
    "name": "John",
    "age": "42 years"
  }.toTable
  friend = {
    "name": "Fred",
    "age": "23 years"
  }.toTable
  food = {
    "name": "cake",
    "age": "2 days",
    "where": "fridge"
  }.toTable
  parsers = [
    initVarParser("{}", (k: string) => me[k]),
    initVarParser("()", (k: string) => friend[k]),
    initVarParser("**", (k: string) => food[k], true)
  ]
echo text.parseStr parsers
# Result:
#   My name is John and I am 42 years old; My friend Fred is 23 years old.
#   My favorite food is called cake, and I've had it in my fridge for 2 days now
```

### `func tryParseInt*(value: string; default = -1): int {.inline.}`

Tries to parse int from string

```nim
doAssert tryParseInt("10") == 10
doAssert tryParseInt("test") == -1
doAssert tryParseInt("test", 12) == 12
```

### `func tryParseFloat*(value: string; default = -1.0): float {.inline.}`

Tries to parse float from string

```nim
doAssert tryParseFloat("10") == 10.0
doAssert tryParseFloat("1.823") == 1.823
doAssert tryParseFloat("test") == -1.0
doAssert tryParseFloat("test", 12) == 12.0
```

### `func tryParseBool*(value: string; default = false): bool {.inline.}`

Tries to parse bool from string

```nim
doAssert tryParseBool("1", false) == true
doAssert tryParseBool("0", true) == false
doAssert tryParseBool("test", true) == true
```

### `func parseValue*[T: BaseType](value: string; default: T): T {.inline.}`

Tries to parse the string to the same type as `default`

```nim
doAssert parseValue("10", 10) == 10
doAssert parseValue("10", 0.0) == 10.0
doAssert parseValue("1", false) == true
doAssert parseValue("true", false) == true
doAssert parseValue("test", false) == false
```

### `proc removeAccent*(str: string): string`

Removes all accents of string

Based in WordPress implementation: https://github.com/WordPress/WordPress/blob/a2693fd8602e3263b5925b9d799ddd577202167d/wp-includes/formatting.php#L1528

```nim
doAssert "ªºÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿØĀāĂăĄąĆćĈĉĊċČčĎďĐđĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħĨĩĪīĬĭĮįİıĲĳĴĵĶķĸĹĺĻļĽľĿŀŁłŃńŅņŇňŉŊŋŌōŎŏŐőŒœŔŕŖŗŘřŚśŜŝŞşŠšŢţŤťŦŧŨũŪūŬŭŮůŰűŲųŴŵŶŷŸŹźŻżŽžſȘșȚț€£ơƯưẦầẰằỀềỒồỜờỪừỲỳẢảẨẩẲẳẺẻỂểỈỉỎỏỔổỞởỦủỬửỶỷẪẫẴẵẼẽỄễỖỗỠỡỮữỸỹẤấẮắẾếỐốỚớỨứẠạẬậẶặẸẹỆệỊịỌọỘộỢợỤụỰựỴỵɑǕǖǗǘǍǎǏǐǑǒǓǔǙǚǛǜ".removeAccent ==
         "aoAAAAAAAECEEEEIIIIDNOOOOOUUUUYTHsaaaaaaaeceeeeiiiidnoooooouuuuythyOAaAaAaCcCcCcCcDdDdEeEeEeEeEeGgGgGgGgHhHhIiIiIiIiIiIJijJjKkkLlLlLlLlLlNnNnNnnNnOoOoOoOEoeRrRrRrSsSsSsSsTtTtTtUuUuUuUuUuUuWwYyYZzZzZzsSsTtEoUuAaAaEeOoOoUuYyAaAaAaEeEeIiOoOoOoUuUuYyAaAaEeEeOoOoUuYyAaAaEeOoOoUuAaAaAaEeEeIiOoOoOoUuUuYyaUuUuAaIiOoUuUuUu"
```

### `timestampToSec*(timestamp: string): int`

Converts a readable timestamp to seconds  
supports:

- 00:00:00
- 00:00

```nim
doAssert "01:06:10".timestampToSec == 3970
doAssert "3:2".timestampToSec == 182
```

### `secToTimestamp*(seconds: int): string`

Converts the seconds to a readable timestamp  
converts to:

- 00:00:00
- 00:00

```nim
doAssert 3970.secToTimestamp == "01:06:10"
doAssert 182.secToTimestamp == "03:02"
doAssert 3600.secToTimestamp == "01:00:00"
```

## _forTerm_ module

### `proc echoSingleLine(xs: varargs[string, `$`])`

Prints in stdout the text replacing the current line, useful to show progress

## _forFs_ module

### `func escapeFs(str: string; toReplace = '-'): string`

Escapes the invalid chars in FS

**Example**

```nim
doAssert "10/2: ?".escapeFs == "10-2- -"
```

## _forSeq_ module

### `proc occurrences*[T](xs: openArray[T]): Table[T, int]`

Get all occurrences of values in array

**Example**

```nim
from std/tables import toTable
doAssert occurrences(["a", "b", "c", "a"]) == {"a": 2, "b": 1, "c": 1}.toTable
doAssert occurrences(["a", "b", "c", "c"]) == {"a": 1, "b": 1, "c": 2}.toTable
doAssert occurrences(["a", "a", "b", "c", "c"]) == {"a": 1, "b": 1, "c": 2}.toTable
```

### `proc occurrence*[T](xs: openArray[T], val: T): int`

Get the occurrence of specific value in array

**Example**

```nim
from std/tables import toTable
doAssert(["a", "b", "c", "a"].occurrence("b") == 1)
doAssert(["a", "b", "c", "c"].occurrence("e") == 0)
doAssert(["a", "a", "b", "c", "c"].occurrence("c") == 2)
```

### `proc mostCommon*[T](xs: openArray[T]): seq[T]`

Get the most common values at array

**Example**

```nim
from std/tables import toTable
doAssert mostCommon(["a", "b", "c", "a"]) == ["a"]
doAssert mostCommon(["a", "b", "c", "c"]) == ["c"]
doAssert mostCommon(["a", "a", "b", "c", "c"]) == ["a", "c"]
```

## _forRand_ module

### `proc randStr*(len: int; chars = Digits + Letters): string`

Generate a random string using given chars

Need call `randomize` before

**Example**

```nim
from std/random import randomize
randomize()
doAssert randStr(10).len == 10
```

---

## _forOs_ module

### `proc getEnv*(key: string; default = ""; encoding = "ibm850"): string`

Get the env and converts it to utf8 if in windows

**Example**

```nim
from std/os import putEnv
putEnv("name", "Joe")
doAssert getEnv("name") == "Joe"
```

---

## _forTime_ module

### `proc nowUnix*: int64 {.inline.}`
Returns the unix time of now
  
**Example**
```nim
doAssert nowUnix() > 1669113763
```

### `proc toUnix*(date: DateTime): int64 {.inline.}`
Returns the unix time of provided date
  
**Example**
```nim
from std/times import fromUnix
doAssert fromUnix(1669113763).toUnix == 1669113763
```
  date.toTime.toUnix


### `proc setMidnight*(date: DateTime): DateTime`
Calculates the next birthday date

Based in https://github.com/rubenwardy/renewedtab/blob/35d0afb8cdf5a3b701e60b137ff1db7110dcc385/src/app/utils/dates.tsx#L7
  
**Example**
```nim
from std/times import fromUnix, utc
doAssert fromUnix(946684999).utc.setMidnight.toUnix == 946684800
```

### `proc nextBirthday*(birth: DateTime; at = now()): DateTime`
Calculates the next birthday date

Based in https://github.com/rubenwardy/renewedtab/blob/35d0afb8cdf5a3b701e60b137ff1db7110dcc385/src/app/utils/dates.tsx#L21
  
**Example**
```nim
from std/times import fromUnix, utc
doAssert fromUnix(946684800).utc.nextBirthday(fromUnix(1671494400).utc).toUnix == 1672531200
```

### `proc lastBirthday*(birth: DateTime; at = now()): DateTime`
Calculates the next birthday date

Based in https://github.com/rubenwardy/renewedtab/blob/35d0afb8cdf5a3b701e60b137ff1db7110dcc385/src/app/utils/dates.tsx#L21
  
**Example**
```nim
from std/times import fromUnix, utc
doAssert fromUnix(946684800).utc.lastBirthday(fromUnix(1671494400).utc).toUnix == 1640995200
```

### `proc yearsOld*(birth: DateTime; at = now()): int {.inline.}`
Calculates the age based on `birth`

Based in https://stackoverflow.com/a/4076440
  
**Example**
```nim
from std/times import fromUnix, utc
doAssert fromUnix(946684800).utc.yearsOld(fromUnix(1671494400).utc) == 22
```

### `proc decimalYearsOld*(birth: DateTime; at = now()): float`
Calculates the age with decimal precision

Based in https://github.com/rubenwardy/renewedtab/blob/35d0afb8cdf5a3b701e60b137ff1db7110dcc385/src/app/utils/dates.tsx#L39
  
**Example**
```nim
from std/times import fromUnix, utc
doAssert fromUnix(946684800).utc.decimalYearsOld(fromUnix(1671494400).utc) == 22.96712328767123
```

---

## License

MIT
