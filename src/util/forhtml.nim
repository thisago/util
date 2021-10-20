## `util`s `forhtml`

proc genclass*(classes: openArray[(string, bool)]): string =
  ## Generate html classname by a array of `(string, bool)`
  runnableExamples:
    doAssert genClass({
      "btn",
      "btn-info": true,
      "hidden": false
    }) == "btn btn-info"
  for i, (class, active) in classes:
    if active:
      result.add class
    if i + 1 < classes.len - 1:
      result.add " "
