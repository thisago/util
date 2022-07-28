## Utilities `forStr`ing

from std/strutils import find

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
