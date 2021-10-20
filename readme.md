# util

Random utilities to all cases.

More will be added soon.

## `forhtml` module

### `func genclass(classes: openArray[(string, bool)]): string`

Generate html classname by a array of `(string, bool)`

**Example**

```nim
doAssert genClass({
  "btn",
  "btn-info": true,
  "hidden": false
}) == "btn btn-info"
```

## License

MIT
