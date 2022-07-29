# Utilities `forTerm`inal

from std/terminal import terminalWidth
from std/strutils import repeat, join

proc echoSingleLine*(xs: varargs[string, `$`]) =
  ## Prints in stdout the text replacing the current line, useful to show progress
  let text = xs.join ""
  stdout.write text & " ".repeat(abs(terminalWidth() - text.len)) & "\r"
