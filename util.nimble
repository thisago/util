# Package

version       = "1.4.0"
author        = "Thiago Navarro"
description   = "Small utilities that isn't large enough to have a individual modules"
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 1.0.0"

task genDocs, "Generate documentation":
  exec "rm -r docs; nim doc --git.commit:master --git.url:https://github.com/thisago/util --project -d:ssl --out:docs ./src/util.nim"
