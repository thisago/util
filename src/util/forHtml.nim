## Utilities `forHtml`
from std/strutils import join

func genClass*(classes: openArray[(string, bool)]): string =
  ## Returns as string just the classes that are on
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
