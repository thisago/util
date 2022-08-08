import std/unittest
from std/sugar import `=>`
from std/tables import toTable, `[]`

import util/forStr

suite "For string":
  test "between":
    check "The dog is lazy".between("dog", "lazy") == " is "
    check "The dog is lazy".between("dog", "lazy", catchAll = true) == "dog is lazy"
    
  test "parseStr":
    let
      text = "My name is {name} and I am {age} old; My friend (name) is (age) old.\l" &
        "My favorite food is called **name**, and I've had it in my **where** for **age** now"
      me = {
        "name": "John",
        "age": "42 years"
      }.toTable
      friend = {
        "name": "Fred",
        "age": "23 years"
      }.toTable
      food = {
        "name": "cake",
        "age": "2 days",
        "where": "fridge"
      }.toTable
      parsers = [
        initVarParser("**", (k: string) => food[k], true),
        initVarParser("{}", (k: string) => me[k]),
        initVarParser("()", (k: string) => friend[k])
      ]
    check text.parseStr(parsers) == "My name is John and I am 42 years old; My friend Fred is 23 years old.\lMy favorite food is called cake, and I've had it in my fridge for 2 days now"
