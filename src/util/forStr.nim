## Utilities `forStr`ing
from std/strutils import find, join
from std/sugar import `->`

func between*(text, start, finish: string; default = ""; catchAll = false): string =
  ## Get the text between two strings
  ## 
  ## If `catchAll` is false, just the middle text will be returned, the searched text will be removed
  runnableExamples:
    const phrase = "The dog is lazy"
    doAssert phrase.between("dog", "lazy") == " is "
    doAssert phrase.between("dog", "lazy", catchAll = true) == "dog is lazy"
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

func setBetween*(text, start, finish, inside: string; default = text; replaceAll = false): string =
  ## Set the text between two strings
  ## 
  ## If text not found, the text will be the default
  ## 
  ## If `replaceAll` is true, it will replace the text used to find too
  runnableExamples:
    const phrase = "I want to eat a large pineapple"
    doAssert phrase.setBetween("a ", " pine", "small") == "I want to eat a small pineapple"
    doAssert phrase.setBetween("a ", " pine", "small ", replaceAll = true) == "I want to eat small apple"
  result = text
  var startIndex = text.find start
  if startIndex >= 0:
    if not replaceAll:
      startIndex += start.len
    var
      res = text[startIndex..^1]
      finishIndex = res.find finish
    if finishIndex >= 0:
      dec finishIndex
      if replaceAll:
        finishIndex += finish.len
      try:
        result = text
        result[startIndex..startIndex + finishIndex] = inside
      except ValueError:
        result = default

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
    doAssert text.parseStr(parsers) == "My name is John and I am 42 years old; My friend Fred is 23 years old.\lMy favorite food is called cake, and I've had it in my fridge for 2 days now"
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

# ---

from std/strutils import parseEnum

func tryParseEnum*[T: enum](value: string; default = T(0)): T {.inline.} =
  ## Tries to parse float from string  
  ## TODO: set default automatically
  runnableExamples:
    type MyEnum = enum
      first = "1st", second, third = "3th"
    doAssert tryParseEnum[MyEnum]("1_st") == first
    doAssert tryParseEnum[MyEnum]("second") == second
    doAssert tryParseEnum[MyEnum]("third") == third
    doAssert tryParseEnum[MyEnum]("4th", first) == first
  try:
    result = parseEnum[T](value)
  except ValueError:
    result = default

from std/strutils import multiReplace

proc removeAccent*(str: string): string =
  ## Removes all accents of string
  ## 
  ## Based in WordPress implementation: https://github.com/WordPress/WordPress/blob/a2693fd8602e3263b5925b9d799ddd577202167d/wp-includes/formatting.php#L1528
  runnableExamples:
    doAssert "ªºÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿØĀāĂăĄąĆćĈĉĊċČčĎďĐđĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħĨĩĪīĬĭĮįİıĲĳĴĵĶķĸĹĺĻļĽľĿŀŁłŃńŅņŇňŉŊŋŌōŎŏŐőŒœŔŕŖŗŘřŚśŜŝŞşŠšŢţŤťŦŧŨũŪūŬŭŮůŰűŲųŴŵŶŷŸŹźŻżŽžſȘșȚț€£ơƯưẦầẰằỀềỒồỜờỪừỲỳẢảẨẩẲẳẺẻỂểỈỉỎỏỔổỞởỦủỬửỶỷẪẫẴẵẼẽỄễỖỗỠỡỮữỸỹẤấẮắẾếỐốỚớỨứẠạẬậẶặẸẹỆệỊịỌọỘộỢợỤụỰựỴỵɑǕǖǗǘǍǎǏǐǑǒǓǔǙǚǛǜ".removeAccent ==
            "aoAAAAAAAECEEEEIIIIDNOOOOOUUUUYTHsaaaaaaaeceeeeiiiidnoooooouuuuythyOAaAaAaCcCcCcCcDdDdEeEeEeEeEeGgGgGgGgHhHhIiIiIiIiIiIJijJjKkkLlLlLlLlLlNnNnNnnNnOoOoOoOEoeRrRrRrSsSsSsSsTtTtTtUuUuUuUuUuUuWwYyYZzZzZzsSsTtEoUuAaAaEeOoOoUuYyAaAaAaEeEeIiOoOoOoUuUuYyAaAaEeEeOoOoUuYyAaAaEeOoOoUuAaAaAaEeEeIiOoOoOoUuUuYyaUuUuAaIiOoUuUuUu"
  result = str.multiReplace({
    # Decompositions for Latin-1 Supplement
    "ª": "a", "º": "o", "À": "A", "Á": "A", "Â": "A", "Ã": "A", "Ä": "A",
    "Å": "A", "Æ": "AE", "Ç": "C", "È": "E", "É": "E", "Ê": "E", "Ë": "E",
    "Ì": "I", "Í": "I", "Î": "I", "Ï": "I", "Ð": "D", "Ñ": "N", "Ò": "O",
    "Ó": "O", "Ô": "O", "Õ": "O", "Ö": "O", "Ù": "U", "Ú": "U", "Û": "U",
    "Ü": "U", "Ý": "Y", "Þ": "TH", "ß": "s", "à": "a", "á": "a", "â": "a",
    "ã": "a", "ä": "a", "å": "a", "æ": "ae", "ç": "c", "è": "e", "é": "e",
    "ê": "e", "ë": "e", "ì": "i", "í": "i", "î": "i", "ï": "i", "ð": "d",
    "ñ": "n", "ò": "o", "ó": "o", "ô": "o", "õ": "o", "ö": "o", "ø": "o",
    "ù": "u", "ú": "u", "û": "u", "ü": "u", "ý": "y", "þ": "th", "ÿ": "y",
    "Ø": "O",
    # Decompositions for Latin Extended-A
    "Ā": "A", "ā": "a", "Ă": "A", "ă": "a", "Ą": "A", "ą": "a", "Ć": "C", 
    "ć": "c", "Ĉ": "C", "ĉ": "c", "Ċ": "C", "ċ": "c", "Č": "C", "č": "c", 
    "Ď": "D", "ď": "d", "Đ": "D", "đ": "d", "Ē": "E", "ē": "e", "Ĕ": "E",
    "ĕ": "e", "Ė": "E", "ė": "e", "Ę": "E", "ę": "e", "Ě": "E", "ě": "e",
    "Ĝ": "G", "ĝ": "g", "Ğ": "G", "ğ": "g", "Ġ": "G", "ġ": "g", "Ģ": "G",
    "ģ": "g", "Ĥ": "H", "ĥ": "h", "Ħ": "H", "ħ": "h", "Ĩ": "I", "ĩ": "i", 
    "Ī": "I", "ī": "i", "Ĭ": "I", "ĭ": "i", "Į": "I", "į": "i", "İ": "I", 
    "ı": "i", "Ĳ": "IJ", "ĳ": "ij", "Ĵ": "J", "ĵ": "j", "Ķ": "K", "ķ": "k",
    "ĸ": "k", "Ĺ": "L", "ĺ": "l", "Ļ": "L", "ļ": "l", "Ľ": "L", "ľ": "l", 
    "Ŀ": "L", "ŀ": "l", "Ł": "L", "ł": "l", "Ń": "N", "ń": "n", "Ņ": "N", 
    "ņ": "n", "Ň": "N", "ň": "n", "ŉ": "n", "Ŋ": "N", "ŋ": "n", "Ō": "O", 
    "ō": "o", "Ŏ": "O", "ŏ": "o", "Ő": "O", "ő": "o", "Œ": "OE", "œ": "oe", 
    "Ŕ": "R", "ŕ": "r", "Ŗ": "R", "ŗ": "r", "Ř": "R", "ř": "r", "Ś": "S", 
    "ś": "s", "Ŝ": "S", "ŝ": "s", "Ş": "S", "ş": "s", "Š": "S", "š": "s",
    "Ţ": "T", "ţ": "t", "Ť": "T", "ť": "t", "Ŧ": "T", "ŧ": "t", "Ũ": "U", 
    "ũ": "u", "Ū": "U", "ū": "u", "Ŭ": "U", "ŭ": "u", "Ů": "U", "ů": "u",
    "Ű": "U", "ű": "u", "Ų": "U", "ų": "u", "Ŵ": "W", "ŵ": "w", "Ŷ": "Y", 
    "ŷ": "y", "Ÿ": "Y", "Ź": "Z", "ź": "z", "Ż": "Z", "ż": "z", "Ž": "Z", 
    "ž": "z", "ſ": "s",
    # Decompositions for Latin Extended-B
    "Ș": "S", "ș": "s", "Ț": "T", "ț": "t",
    # Euro Sign
    "€": "E",
    # GBP (Pound) Sign
    "£": "",
    # Vowels with diacritic (Vietnamese)
    # unmarked
    "Ơ": "O", "ơ": "o", "Ư": "U", "ư": "u",
    # grave accent
    "Ầ": "A", "ầ": "a", "Ằ": "A", "ằ": "a", "Ề": "E", "ề": "e", "Ồ": "O",
    "ồ": "o", "Ờ": "O", "ờ": "o", "Ừ": "U", "ừ": "u", "Ỳ": "Y", "ỳ": "y",
    # hook
    "Ả": "A", "ả": "a", "Ẩ": "A", "ẩ": "a", "Ẳ": "A", "ẳ": "a", "Ẻ": "E",
    "ẻ": "e", "Ể": "E", "ể": "e", "Ỉ": "I", "ỉ": "i", "Ỏ": "O", "ỏ": "o",
    "Ổ": "O", "ổ": "o", "Ở": "O", "ở": "o", "Ủ": "U", "ủ": "u", "Ử": "U",
    "ử": "u", "Ỷ": "Y", "ỷ": "y",
    # tilde
    "Ẫ": "A", "ẫ": "a", "Ẵ": "A", "ẵ": "a", "Ẽ": "E", "ẽ": "e", "Ễ": "E",
    "ễ": "e", "Ỗ": "O", "ỗ": "o", "Ỡ": "O", "ỡ": "o", "Ữ": "U", "ữ": "u",
    "Ỹ": "Y", "ỹ": "y",
    # acute accent
    "Ấ": "A", "ấ": "a", "Ắ": "A", "ắ": "a", "Ế": "E", "ế": "e", "Ố": "O",
    "ố": "o", "Ớ": "O", "ớ": "o", "Ứ": "U", "ứ": "u",
    # dot below
    "Ạ": "A", "ạ": "a", "Ậ": "A", "ậ": "a", "Ặ": "A", "ặ": "a", "Ẹ": "E",
    "ẹ": "e", "Ệ": "E", "ệ": "e", "Ị": "I", "ị": "i", "Ọ": "O", "ọ": "o",
    "Ộ": "O", "ộ": "o", "Ợ": "O", "ợ": "o", "Ụ": "U", "ụ": "u", "Ự": "U",
    "ự": "u", "Ỵ": "Y", "ỵ": "y",
    # Vowels with diacritic (Chinese, Hanyu Pinyin)
    "ɑ": "a",
    # macron
    "Ǖ": "U", "ǖ": "u",
    # acute accent
    "Ǘ": "U", "ǘ": "u",
    # caron
    "Ǎ": "A", "ǎ": "a", "Ǐ": "I", "ǐ": "i", "Ǒ": "O", "ǒ": "o", "Ǔ": "U",
    "ǔ": "u", "Ǚ": "U", "ǚ": "u",
    # grave accent
    "Ǜ": "U", "ǜ": "u",
  })

from std/strutils import split
from std/strformat import fmt

proc timestampToSec*(timestamp: string): int =
  ## Converts a readable timestamp to seconds  
  ## supports:
  ## - 00:00:00
  ## - 00:00
  runnableExamples:
    doAssert "01:06:10".timestampToSec == 3970
    doAssert "3:2".timestampToSec == 182
  result = -1
  let parts = timestamp.split ":"
  if parts.len >= 2:
    try:
      result = 0
      if parts.len == 3:
        result += parts[0].parseInt * 60 * 60 # hours
      result += parts[^2].parseInt * 60 # minutes
      result += parts[^1].parseInt # seconds
    except ValueError:
      result = -1

proc secToTimestamp*(seconds: int): string =
  ## Converts the seconds to a readable timestamp  
  ## converts to:
  ## - 00:00:00
  ## - 00:00
  runnableExamples:
    doAssert secToTimestamp 3970 == "01:06:10"
    doAssert secToTimestamp 182 == "03:02"
    doAssert secToTimestamp 3600 == "01:00:00"
  result = ""
  var
    s = seconds
    secs = 0
    mins = 0
    hrs = 0
  while s > 0:
    if s >= 60:
      inc mins
      s -= 60
      if mins >= 60:
        inc hrs
        mins -= 60
    else:
      secs = s
      s = 0
  if hrs > 0:
    result = fmt"{hrs:02}:"
  result.add fmt"{mins:02}:{secs:02}"
