import std/unittest
import util/forhtml

suite "For HTML":
  test "genclass":
    check genClass({
      "btn",
      "btn-info": true,
      "hidden": false
    }) == "btn btn-info"
