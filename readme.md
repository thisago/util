# util

Small utilities that isn't large enough to have a individual modules

## _forHtml_ module

### `func genclass(classes: openArray[(string, bool)]): string`

Returns as string just the classes that are on

**Example**

```nim
doAssert genClass({
  "btn",
  "btn-info": true,
  "hidden": false
}) == "btn btn-info"
```

---

## _forStr_ module

### `func between(text, start, finish: string; default = ""; catchAll = false): string`

Get the text between two strings

If `justMiddle` is true, just the middle text will be returned, the searched text will be removed

**Example**

```nim
doAssert "The dog is lazy".between("dog", "lazy") == " is "
doAssert "The dog is lazy".between("dog", "lazy", catchAll = true) == "dog is lazy"
```

## _forTerm_ module

### `proc echoSingleLine(xs: varargs[string, `$`])`

Prints in stdout the text replacing the current line, useful to show progress

## _forFs_ module

### `func escapeFs(str: string; toReplace = '-'): string`

Escapes the invalid chars in FS

**Example**

```nim
doAssert "10/2: ?".escapeFs == "10-2- -"
```

## License

MIT
