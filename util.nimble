# Package

version       = "0.1.2"
author        = "Thiago Ferreira"
description   = "Random utilities to all cases"
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 1.0.0"

task gen_docs, "Generates the documentation":
  exec "nim doc --project --out:docs src/util.nim"
