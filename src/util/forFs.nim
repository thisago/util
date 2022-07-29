## Utilities `forFs` (File System)

const InvalidChars* = {'/','\\',':','*','?','"','<','>'}
func escapeFs*(str: string; toReplace = '-'): string =
  ## Escapes the invalid chars in FS
  runnableExamples:
    doAssert escapeFs "10/2: ?" == "10-2- -"
  for ch in str:
    if ch notin InvalidChars:
      result.add ch
    else:
      result.add toReplace
