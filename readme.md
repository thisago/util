# util

Small utilities that isn't large enough to have a individual modules

## _forHtml_ module

### `func genclass(classes: openArray[(string, bool)]): string`

<a href="https://thisago.github.io/util/util/forHtml.html#genClass%2CopenArray%5B%5D"><small>Source</small></a>

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

<a href="https://thisago.github.io/util/util/forStr.html#between%2Cstring%2Cstring%2Cstring%2Cstring"><small>Source</small></a>

Get the text between two strings

If `justMiddle` is true, just the middle text will be returned, the searched text will be removed

**Example**

```nim
doAssert "The dog is lazy".between("dog", "lazy") == " is "
doAssert "The dog is lazy".between("dog", "lazy", catchAll = true) == "dog is lazy"
```

### `func stopAt*(s, stop: string or char): string`

<a href="https://thisago.github.io/util/util/forStr.html#stopAt%2C%2C"><small>Source</small></a>

Removes all text after `stop` (and the `stop` text too)

**Example**

```nim
doAssert "Hello World! My name is John".stopAt('!') == "Hello World"
```

### `proc parseStr*(text: string; parsers: varargs[VarParser]): string`

<a href="https://thisago.github.io/util/util/forStr.html#parseStr%2Cstring%2Cvarargs%5BVarParser%5D"><small>Source</small></a>

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

## _forTerm_ module

### `proc echoSingleLine(xs: varargs[string, `$`])`

<a href="https://thisago.github.io/util/util/forTerm.html#echoSingleLine%2Cvarargs%5Bstring%2C%5D"><small>Source</small></a>

Prints in stdout the text replacing the current line, useful to show progress

## _forFs_ module

### `func escapeFs(str: string; toReplace = '-'): string`

<a href="https://thisago.github.io/util/util/forFs.html#escapeFs%2Cstring%2Cchar"><small>Source</small></a>

Escapes the invalid chars in FS

**Example**

```nim
doAssert "10/2: ?".escapeFs == "10-2- -"
```

## _forSeq_ module

### `proc occurrences*[T](xs: openArray[T]): Table[T, int]`

<a href="https://thisago.github.io/util/util/forSeq.html#occurrences%2CopenArray%5BT%5D"><small>Source</small></a>

Get all occurrences of values in array

**Example**

```nim
from std/tables import toTable
doAssert occurrences(["a", "b", "c", "a"]) == {"a": 2, "b": 1, "c": 1}.toTable
doAssert occurrences(["a", "b", "c", "c"]) == {"a": 1, "b": 1, "c": 2}.toTable
doAssert occurrences(["a", "a", "b", "c", "c"]) == {"a": 1, "b": 1, "c": 2}.toTable
```

### `proc occurrence*[T](xs: openArray[T], val: T): int`

<a href="https://thisago.github.io/util/util/forSeq.html#occurrence%2CopenArray%5BT%5D%2CT"><small>Source</small></a>

Get the occurrence of specific value in array

**Example**

```nim
from std/tables import toTable
doAssert(["a", "b", "c", "a"].occurrence("b") == 1)
doAssert(["a", "b", "c", "c"].occurrence("e") == 0)
doAssert(["a", "a", "b", "c", "c"].occurrence("c") == 2)
```

### `proc mostCommon*[T](xs: openArray[T]): seq[T]`

<a href="https://thisago.github.io/util/util/forSeq.html#mostCommon%2CopenArray%5BT%5D"><small>Source</small></a>

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

<a href="https://thisago.github.io/util/util/forRand.html#randStr%2Cint"><small>Source</small></a>

Generate a random string using given chars

Need call `randomize` before

**Example**

```nim
from std/random import randomize
randomize()
doAssert randStr(10).len == 10
```

---

## License

MIT
