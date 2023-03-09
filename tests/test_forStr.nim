import std/unittest
from std/sugar import `=>`
from std/tables import toTable, `[]`

import util/forStr

suite "For string":
  test "between":
    const phrase = "The dog is lazy"
    check phrase.between("dog", "lazy") == " is "
    check phrase.between("dog", "lazy", catchAll = true) == "dog is lazy"
  
  test "setBetween":
    const phrase = "I want to eat a large pineapple"
    check phrase.setBetween("a ", " pine", "small") == "I want to eat a small pineapple"
    check phrase.setBetween("a ", " pine", "small ", replaceAll = true) == "I want to eat small apple"
    
  test "stopAt":
    check "Hello World! My name is John".stopAt('!') == "Hello World"
    
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

  test "tryParseInt":
    check tryParseInt("10") == 10
    check tryParseInt("test") == -1
    check tryParseInt("test", 12) == 12
  test "tryParseFloat":
    check tryParseFloat("10") == 10.0
    check tryParseFloat("1.823") == 1.823
    check tryParseFloat("test") == -1.0
    check tryParseFloat("test", 12) == 12.0
  test "tryParseBool":
    check tryParseBool("1", false) == true
    check tryParseBool("0", true) == false
    check tryParseBool("test", true) == true
  test "parseValue":
    check parseValue("10", 10) == 10
    check parseValue("10", "") == "10"
    check parseValue("10", 0.0) == 10.0
    check parseValue("1", false) == true
    check parseValue("true", false) == true
    check parseValue("test", false) == false
  test "tryParseEnum":
    type MyEnum = enum
      first = "1st", second, third = "3th"
    check tryParseEnum[MyEnum]("1_st") == first
    check tryParseEnum[MyEnum]("second") == second
    check tryParseEnum[MyEnum]("3th") == third
    check tryParseEnum[MyEnum]("4th", first) == first
  test "removeAccent":
    check "ªºÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿØĀāĂăĄąĆćĈĉĊċČčĎďĐđĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħĨĩĪīĬĭĮįİıĲĳĴĵĶķĸĹĺĻļĽľĿŀŁłŃńŅņŇňŉŊŋŌōŎŏŐőŒœŔŕŖŗŘřŚśŜŝŞşŠšŢţŤťŦŧŨũŪūŬŭŮůŰűŲųŴŵŶŷŸŹźŻżŽžſȘșȚț€£ơƯưẦầẰằỀềỒồỜờỪừỲỳẢảẨẩẲẳẺẻỂểỈỉỎỏỔổỞởỦủỬửỶỷẪẫẴẵẼẽỄễỖỗỠỡỮữỸỹẤấẮắẾếỐốỚớỨứẠạẬậẶặẸẹỆệỊịỌọỘộỢợỤụỰựỴỵɑǕǖǗǘǍǎǏǐǑǒǓǔǙǚǛǜ".removeAccent ==
          "aoAAAAAAAECEEEEIIIIDNOOOOOUUUUYTHsaaaaaaaeceeeeiiiidnoooooouuuuythyOAaAaAaCcCcCcCcDdDdEeEeEeEeEeGgGgGgGgHhHhIiIiIiIiIiIJijJjKkkLlLlLlLlLlNnNnNnnNnOoOoOoOEoeRrRrRrSsSsSsSsTtTtTtUuUuUuUuUuUuWwYyYZzZzZzsSsTtEoUuAaAaEeOoOoUuYyAaAaAaEeEeIiOoOoOoUuUuYyAaAaEeEeOoOoUuYyAaAaEeOoOoUuAaAaAaEeEeIiOoOoOoUuUuYyaUuUuAaIiOoUuUuUu"
  test "timestampToSec":
    check "01:06:10".timestampToSec == 3970
    check "3:2".timestampToSec == 182
  test "secToTimestamp":
    check secToTimestamp(3970) == "01:06:10"
    check secToTimestamp(182) == "03:02"
    check secToTimestamp(3600) == "01:00:00"
  test "getAllFirstLevelParenthesis":
    check "(a(b(c))) test (d(e(f))) test".getAllFirstLevelParenthesis == @[
      "a(b(c))",
      "d(e(f))"
    ]
  test "strip":
    check "ááźtest heállÊo".strip(RunesWithAccent) == "test hello"
    check "### `func almoçarComÁgua(comida, litros: string): string`".
      strip(chars = NonExtendedAlphanumeric) == "funcalmoçarComÁguacomidalitrosstringstring"
