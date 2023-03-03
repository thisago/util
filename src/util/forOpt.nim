# Utilities for `std/options`
from std/options import Option, get, UnpackDefect

func tryGet*[T](o: Option[T]; default: T): T =
  ## Try to get Option value, if none, returns default
  runnableExamples:
    from std/options import some, none
    doAssert some("hi").tryGet("bye") == "hi"
    doAssert none(string).tryGet("bye") == "bye"
  result = default
  try: result = o.get
  except UnpackDefect: discard
