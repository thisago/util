## Utilities `forOs` (Operating System)

from std/encodings import convert
from std/os import nil

proc getEnv*(key: string; default = ""; encoding = "ibm850"): string =
  ## Get the env and converts it to utf8 if in windows
  runnableExamples:
    from std/os import putEnv
    putEnv("name", "Joe")
    doAssert getEnv("name") == "Joe"
  result = os.getEnv(key, default)
  when defined windows:
    result = result.convert("UTF-8", encoding) 

when isMainModule:
  from std/os import putEnv
  putEnv("name", "Joe")
  doAssert getEnv("name") == "Joe"
