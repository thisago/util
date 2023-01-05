# Changelog

## Version 1.10.1 (Thu 5 Jan 2023)

- Added auto default for `forStr.tryParseEnum`

---

## Version 1.10.0 (Thu 5 Jan 2023)

- Added `forStr.tryParseEnum`

---

## Version 1.9.1 (Fri 23 Dec 2022)

- Added tests for CNPJ

---

## Version 1.9.0 (Fri 23 Dec 2022)

- Added cnpj testing and generation
 
---

## Version 1.8.1 (Fri 23 Dec 2022)

- Added `forRand.randSeq` test
- Added tests for `forId` module
 
---

## Version 1.8.0 (Fri 23 Dec 2022)

- Added `forRand.randSeq`
- Added `forId` module with
  - CPF generation
  - CPF verification
  - CPF parsing
  
---

## Version 1.7.0 (Tue Nov 22, 2022)

- Added: `forStr.setBetween` - Set the text between two strings

---

## Version 1.6.0 (Tue Nov 22, 2022)

- Added:
  - `forTime.nowUnix` - Returns the unix time of now
  - `forTime.toUnix` - Returns the unix time of provided date
  - `forTime.setMidnight` - Calculates the next birthday date
  - `forTime.nextBirthday` - Calculates the next birthday date
  - `forTime.lastBirthday` - Calculates the next birthday date
  - `forTime.yearsOld` - Calculates the age based on `birth`
  - `forTime.decimalYearsOld` - Calculates the age with decimal precision

---

## Version 1.5.2 (Thu Nov 18, 2022)

- Fixed `forOs.getEnv` correct encoding for windows

---

## Version 1.5.1 (Thu Nov 18, 2022)

- Fixed `forOs.getEnv`

---

## Version 1.5.0 (Thu Nov 17, 2022)

- Added `forOs.getEnv`

---

## Version 1.4.0 (Oct 11 2022)

- Added `forStr.secToTimestamp`

---

## Version 1.3.0 (Oct 9 2022)

- Added `forStr.timestampToSec`

---

## Version 1.2.0 (Aug 31 2022)

- Added `forStr.removeAccent`

---

## Version 1.1.0 (Aug 28 2022)

- Added try parse functions an a proc to parse to type of the default value

---

## Version 1.0.0 (Aug 17 2022)

- [BREAKING CHANGE] Renamed submodule `forData` to `forSeq`

---

## Version 0.8.0 (Aug 17 2022)

- Added `forStr.stopAt` to get all text before some identifier

---

## Version 0.7.2 (Aug 8 2022)

- Fixed `forStr.parseStr` parser index not incrementing because there was a `continue`

---

## Version 0.7.1 (Aug 8 2022)

- Removed duplicated `randStr`

---

## Version 0.7.0 (Aug 8 2022)

- Added `forStr.parseStr`

---

## Version 0.6.0 (Aug 5 2022)

- Added `forRand.randStr`

---

## Version 0.5.0 (Aug 5 2022)

- Added `forSeq.occurrences`, `forSeq.occurrence` and `forSeq.mostCommon`

---

## Version 0.4.0 (Jul 29 2022)

- Added `forFs.escapeFs` to escape invalid chars from file names

---

## Version 0.3.0 (Jul 29 2022)

- Added `forTerm.echoSingleLine` to print the text in same line

---

## Version 0.2.1 (Jul 28 2022)

- Allowed the import of all modules at once

---

## Version 0.2.0 (Jul 28 2022)

- Fixed doc gen
- Fixed `forHtml.genClass` name and doc
- Added `forStr.between`

---

## Version 0.1.3 (10/22/2021)

- Changed the way of join data `forhtml.genclass`

---

## Version 0.1.2 (10/22/2021)

- Fixed adding spaces for disabled class in `forhtml.genclass`

---

## Version 0.1.1 (10/20/2021)

- Changed `forhtml.genclass` to a `func`

---

## Version 0.1.0 (10/20/2021)

- Added `forhtml.genclass`
