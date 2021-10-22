import std/unittest
import util/forhtml

suite "For HTML":
  test "genclass":
    check genClass({
      "btn": true,
      "hidden": false,
      "btn-danger": false,
      "btn-info": true
    }) == "btn btn-info"
