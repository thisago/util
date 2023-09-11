## Utilities `forFs` (File System)
from std/strutils import Whitespace, Digits, Letters, strip
from std/setutils import toSet

func escapeFs*(
  str: string;
  allowedChars = Digits + Letters + {'-', '_', '.'};
  toReplace = "-";
  whitespace = ""
): string =
  ## Escapes the invalid chars in FS
  runnableExamples:
    doAssert escapeFs("10/2: ?") == "10-2"
    doAssert "hello world!".escapeFs(whitespace = "_") == "hello_world"
  assert toReplace.len < 2
  assert whitespace.len < 2
  for ch in str:
    if ch in Whitespace:
      result.add whitespace
    elif ch in allowedChars:
      result.add ch
    else:
      result.add toReplace
  let toStrip = ((if toReplace.len == 1: $toReplace[0] else: "") &
                 (if whitespace.len == 1: $whitespace[0] else: "")).toSet
  result = result.strip(chars = Whitespace + toStrip)
