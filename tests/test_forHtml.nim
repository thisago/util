import std/unittest

import util/forHtml

suite "For HTML":
  test "genClass":
    check genClass({
      "btn": true,
      "hidden": false,
      "btn-danger": false,
      "btn-info": true
    }) == "btn btn-info"
