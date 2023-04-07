# Package

version       = "2.0.0"
author        = "Thiago Navarro"
description   = "Small utilities that isn't large enough to have a individual modules"
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 1.0.0"

task testAll, "Test using docs and tests files":
  exec "nimble test"
  exec "nim doc --project --out:docs src/util.nim"
  echo "All tests succeeded!"
