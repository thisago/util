## `util`s `forhtml`
from std/strutils import join

func genclass*(classes: openArray[(string, bool)]): string =
  ## Generate html classname by a array of `(string, bool)`
  runnableExamples:
    doAssert genClass({
      "btn",
      "btn-info": true,
      "hidden": false
    }) == "btn btn-info"
  var activeClasses: seq[string]
  for i, (class, active) in classes:
    if active:
      activeClasses.add class
  result = activeClasses.join " "
