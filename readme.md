# util

Random utilities to all cases.

More will be added soon.

## forhtml

### `genclass`

Generate html classname by a array of `(string, bool)`

**Example**

```nim
doAssert genClass({
  "btn",
  "btn-info": true,
  "hidden": false
}) == "btn btn-info"
```
