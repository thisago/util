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

### `const NonAlphanumeric*`

A set with all non alphanumeric chars (no accents)

### `const RunesWithAccent*`

A set with all accent chars in Runes

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
const phrase = "I want to eat a large pineapple"
doAssert phrase.setBetween("a ", " pine", "small") == "I want to eat a small pineapple"
doAssert phrase.setBetween("a ", " pine", "small ", replaceAll = true) == "I want to eat small apple"
```

### `func stopAt*(s, stop: string or char): string`

Removes all text after `stop` (and the `stop` text too)

**Example**

```nim
doAssert "Hello World! My name is John".stopAt('!') == "Hello World"
```

### `proc parseStr*(text: string; parsers: varargs[VarParser]): string`

Parse variables using custom config

**Example**

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
    doAssert text.parseStr(parsers) == "My name is John and I am 42 years old; My friend Fred is 23 years old.\lMy favorite food is called cake, and I've had it in my fridge for 2 days now"
```

### `func tryParseInt*(value: string; default = -1): int {.inline.}`

Tries to parse int from string

**Example**

```nim
doAssert tryParseInt("10") == 10
doAssert tryParseInt("test") == -1
doAssert tryParseInt("test", 12) == 12
```

### `func tryParseFloat*(value: string; default = -1.0): float {.inline.}`

Tries to parse float from string

**Example**

```nim
doAssert tryParseFloat("10") == 10.0
doAssert tryParseFloat("1.823") == 1.823
doAssert tryParseFloat("test") == -1.0
doAssert tryParseFloat("test", 12) == 12.0
```

### `func tryParseBool*(value: string; default = false): bool {.inline.}`

Tries to parse bool from string

**Example**

```nim
doAssert tryParseBool("1", false) == true
doAssert tryParseBool("0", true) == false
doAssert tryParseBool("test", true) == true
```

### `func parseValue*[T: BaseType](value: string; default: T): T {.inline.}`

Tries to parse the string to the same type as `default`

**Example**

```nim
doAssert parseValue("10", 10) == 10
doAssert parseValue("10", 0.0) == 10.0
doAssert parseValue("1", false) == true
doAssert parseValue("true", false) == true
doAssert parseValue("test", false) == false
```

### `func tryParseEnum*[T: enum](value: string; default: T): T {.inline.}`

Tries to parse float from string

**Example**

```nim
type MyEnum = enum
  first = "1st", second, third = "3th"
doAssert tryParseEnum[MyEnum]("1_st") == first
doAssert tryParseEnum[MyEnum]("second") == second
doAssert tryParseEnum[MyEnum]("third") == third
doAssert tryParseEnum[MyEnum]("4th", first) == first
```

### `proc removeAccent*(str: string): string`

Removes all accents of string

Based in WordPress implementation: https://github.com/WordPress/WordPress/blob/a2693fd8602e3263b5925b9d799ddd577202167d/wp-includes/formatting.php#L1528

**Example**

```nim
doAssert "ªºÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿØĀāĂăĄąĆćĈĉĊċČčĎďĐđĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħĨĩĪīĬĭĮįİıĲĳĴĵĶķĸĹĺĻļĽľĿŀŁłŃńŅņŇňŉŊŋŌōŎŏŐőŒœŔŕŖŗŘřŚśŜŝŞşŠšŢţŤťŦŧŨũŪūŬŭŮůŰűŲųŴŵŶŷŸŹźŻżŽžſȘșȚț€£ơƯưẦầẰằỀềỒồỜờỪừỲỳẢảẨẩẲẳẺẻỂểỈỉỎỏỔổỞởỦủỬửỶỷẪẫẴẵẼẽỄễỖỗỠỡỮữỸỹẤấẮắẾếỐốỚớỨứẠạẬậẶặẸẹỆệỊịỌọỘộỢợỤụỰựỴỵɑǕǖǗǘǍǎǏǐǑǒǓǔǙǚǛǜ".removeAccent ==
         "aoAAAAAAAECEEEEIIIIDNOOOOOUUUUYTHsaaaaaaaeceeeeiiiidnoooooouuuuythyOAaAaAaCcCcCcCcDdDdEeEeEeEeEeGgGgGgGgHhHhIiIiIiIiIiIJijJjKkkLlLlLlLlLlNnNnNnnNnOoOoOoOEoeRrRrRrSsSsSsSsTtTtTtUuUuUuUuUuUuWwYyYZzZzZzsSsTtEoUuAaAaEeOoOoUuYyAaAaAaEeEeIiOoOoOoUuUuYyAaAaEeEeOoOoUuYyAaAaEeOoOoUuAaAaAaEeEeIiOoOoOoUuUuYyaUuUuAaIiOoUuUuUu"
```

### `timestampToSec*(timestamp: string): int`

Converts a readable timestamp to seconds  
supports:

- 00:00:00
- 00:00

**Example**

```nim
doAssert "01:06:10".timestampToSec == 3970
doAssert "3:2".timestampToSec == 182
```

### `secToTimestamp*(seconds: int): string`

Converts the seconds to a readable timestamp  
converts to:

- 00:00:00
- 00:00

**Example**

```nim
doAssert 3970.secToTimestamp == "01:06:10"
doAssert 182.secToTimestamp == "03:02"
doAssert 3600.secToTimestamp == "01:00:00"
```

### `getAllFirstLevelParenthesis*(s: string): seq[string]`

Returns the fist level parenthesis content of string

**Example**

```nim
doAssert "(a(b(c))) test (d(e(f))) test".getAllFirstLevelParenthesis == @[
  "a(b(c))",
  "d(e(f))"
]
```

### `func strip*(s: string; chars: seq[Rune]): string`

strip Runes!

**Example**

```nim
doAssert "ááźtest heállÊo".strip(RunesWithAccent) == "test hello"
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

### `proc newRandSeq(len, max: int; min = 0): seq[int]`

Generates an array with the provided `len` with the random
numbers less or equals than `max`

**Example**

```nim
from std/random import randomize
randomize 0
doAssert randSeq(5, 5) == @[1, 1, 2, 3, 0]
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

<!-- date.toTime.toUnix -->

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

## _forId_ module

### `func genCpfVerificationDigits*(digits: openArray[int]): array[2, int]`

Generates the CPF verification code

**Example**

```nim
from std/random import randomize
randomize()
doAssert [1, 1, 1, 4, 4, 4, 7, 7, 7].genCpfVerificationDigits == [3, 5]
```

### `proc genCpf*(formatted = true; valid = true): string`

Brazil CPF generator
Based in https://www.macoratti.net/alg_cpf.htm

**Example**

```nim
from std/random import randomize
randomize()
doAssert genCpf(formatted = true).len == 14
doAssert genCpf(formatted = false).len == 11
```

### `func parseCpf*(cpf: string): ParsedCpf`

Strip and parses the cpf

**Example**

```nim
let parsed = "111.444.777-35".parseCpf
doAssert parsed.firstDigits == [1, 1, 1, 4, 4, 4, 7, 7, 7]
doAssert parsed.verification == [3, 5]
```

### `proc validCpf*(cpf: string): bool`

Checks if the given CPF is valid

**Example**

```nim
from std/random import randomize
randomize()
doAssert validCpf "111.444.777-35"
doAssert not validCpf "111.444.777-99"
```

### `func genCnpjVerificationDigits*(digits: openArray[int]): array[2, int]`

Generates the CNPJ verification code

**Example**

```nim
from std/random import randomize
randomize()
doAssert [2, 4, 3, 8, 2, 7, 5, 3, 0, 0, 0, 1].genCnpjVerificationDigits == [7, 7]
```

### `func parseCnpj*(cpf: string): ParsedCnpj`

Strip and parses the CNPJ

**Example**

```nim
let parsed = "11.222.333/0001-81".parseCnpj
doAssert parsed.code == [1,1,2,2,2,3,3,3,0,0,0,1]
doAssert parsed.verification == [8,1]
```

### `proc genCnpj*(formatted = true; valid = true): string`

Brazil CNPJ generator  
Based in https://www.macoratti.net/alg_cnpj.htm

**Example**

```nim
from std/random import randomize
randomize()
doAssert genCnpj(formatted = true).len == 18
doAssert genCnpj(formatted = false).len == 14
```

### `proc validCnpj*(cpf: string): bool`

Checks if the given CNPJ is valid

**Example**

```nim
from std/random import randomize
randomize()
doAssert validCnpj "11.222.333/0001-81"
doAssert not validCnpj "11.222.333/0001-99"
```

## _forOpt_ module

### `func tryGet*[T](o: Option[T]; default: T): T`

Try to get Option value, if none, returns default

**Example**

```nim
from std/options import some, none
doAssert some("hi").tryGet("bye") == "hi"
doAssert none(string).tryGet("bye") == "bye"
```

---

## License

MIT
