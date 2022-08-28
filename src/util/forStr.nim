## Utilities `forStr`ing
from std/strutils import find, join
from std/sugar import `->`

func between*(text, start, finish: string; default = ""; catchAll = false): string =
  ## Get the text between two strings
  ## 
  ## If `justMiddle` is true, just the middle text will be returned, the searched text will be removed
  runnableExamples:
    doAssert "The dog is lazy".between("dog", "lazy") == " is "
    doAssert "The dog is lazy".between("dog", "lazy", catchAll = true) == "dog is lazy"
  result = default
  var startIndex = text.find start
  if startIndex >= 0:
    if not catchAll:
      startIndex += start.len
    var
      res = text[startIndex..^1]
      finishIndex = res.find finish
    if finishIndex >= 0:
      dec finishIndex
      if catchAll:
        finishIndex += finish.len
      try:
        result = res[0..finishIndex]
      except ValueError:
        discard

func stopAt*(s, stop: string or char): string =
  ## Removes all text after `stop` (and the `stop` text too)
  runnableExamples:
    doAssert "Hello World! My name is John".
                stopAt('!') == "Hello World"
  result = s
  let stop = s.find stop
  if stop >= 0:
    result = s[0..<stop]


#region var parser (maybe move to another lib)

type
  VarParser* = object
    enclosing*: string
    same*: bool
    fn*: (key: string) -> string

func initVarParser*(
  enclosing: VarParser.enclosing;
  fn: VarParser.fn,
  sameEnclosing = false
): VarParser =
  ## Initialize a new `VarParser`
  ## 
  ## You can use the `sameEnclosing` to open and close variable substitution
  ## 
  ## Same `enclosing` chars and not `sameEnclosing` don't will work
  VarParser(
    enclosing: enclosing,
    same: sameEnclosing,
    fn: fn,
  )

proc parseStr*(text: string; parsers: varargs[VarParser]): string =
  ## Parse variables using custom config
  runnableExamples:
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
  let stopTextLen = text.len - 1
  var
    curr: tuple[index: int; text: string] = (-1, "")
    temp = ""
    parts: seq[string]
    skip = 0
  # Add non var text
  for i, ch in text:
    # Skip char if needed
    if skip > 0:
      dec skip
      continue
    
    # Add raw char if no var is being processed
    if curr.index == -1:
      temp.add ch

    # Eval vars
    for p, parser in parsers:
      if not parser.same:
        if curr.index == p:
          # Stop not same enclosed var and
          if ch == parser.enclosing[1]:
            curr = (-1, parser.fn curr.text)
          else:
            # Add not same enclosed var name
            curr.text.add ch
        else:
          # Start not same enclosed var
          if ch == parser.enclosing[0]: curr = (p, "")
      else:
        # Check same enclosed var start/end
        if text.len >= parser.enclosing.len + i and text[i..<parser.enclosing.len + i] == parser.enclosing:
          # Skip the next chars that can be part of the var usage
          skip = parser.enclosing.len - 1

          # If some char was added before, remove it
          if temp.len > 0:
            temp.setLen temp.len - 1
          if curr.index != p:
            # If not started, start (start name getting)
            curr = (p, "")
          else:
            # If started, parse the var (end of the name getting)
            curr = (-1, parser.fn curr.text)
          continue
        # Add same enclosed var name
        if curr.index == p:
          curr.text.add ch

    # Add resolved var to parts
    if curr.index == -1 and curr.text != "":
      parts.add curr.text
      curr.text = ""
      temp = ""
    # Add temp to parts
    elif temp.len > 0:
      if ch in ['/', ' ', '"', '\\'] or i == stopTextLen:
        parts.add temp
        temp = "" 
  # Join parts
  result = parts.join ""

#endregion


# Source: https://github.com/planety/prologue/blob/devel/src/prologue/core/types.nim#L56

from std/strutils import parseInt, parseFloat, parseBool

type BaseType* = int | float | bool | string

func tryParseInt*(value: string; default = -1): int {.inline.} =
  ## Tries to parse int from string
  runnableExamples:
    doAssert tryParseInt("10") == 10
    doAssert tryParseInt("test") == -1
    doAssert tryParseInt("test", 12) == 12
  try:
    result = parseInt(value)
  except ValueError:
    result = default

func tryParseFloat*(value: string; default = -1.0): float {.inline.} =
  ## Tries to parse float from string
  runnableExamples:
    doAssert tryParseFloat("10") == 10.0
    doAssert tryParseFloat("1.823") == 1.823
    doAssert tryParseFloat("test") == -1.0
    doAssert tryParseFloat("test", 12) == 12.0
  try:
    result = parseFloat(value)
  except ValueError:
    result = default

func tryParseBool*(value: string; default = false): bool {.inline.} =
  ## Tries to parse bool from string
  runnableExamples:
    doAssert tryParseBool("1", false) == true
    doAssert tryParseBool("0", true) == false
    doAssert tryParseBool("test", true) == true
  try:
    result = parseBool(value)
  except ValueError:
    result = default

func parseValue*[T: BaseType](value: string; default: T): T {.inline.} =
  ## Tries to parse the string to the same type as `default`
  runnableExamples:
    doAssert parseValue("10", 10) == 10
    doAssert parseValue("10", 0.0) == 10.0
    doAssert parseValue("1", false) == true
    doAssert parseValue("true", false) == true
    doAssert parseValue("test", false) == false
  if value.len == 0:
    return default

  when T is int:
    result = tryParseInt(value, default)
  elif T is float:
    result = tryParseFloat(value, default)
  elif T is bool:
    result = tryParseBool(value, default)
  elif T is string:
    result = value
