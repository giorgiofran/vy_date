# Changelog

## 1.0.1

- Lints

## 1.0.0-nullsafety

Pre-release for non nullable data types.

### Breaking changes

- Date.parse() now throws an error if the parsed string is empty instead of returning null. A tryParse method is provided to maintain the old functionality.

## 0.4.3

- License update

## 0.4.2

- Lint cleanup

## 0.4.1

- Package Intl ^0.16.0 instead of ^0.15.7
- Added toYMMddString() and parseYMMddString().
  The behavior of these functions is to format and parse a date in a way similar to YMd(), with the difference
  that month and day are padded with 0 when the length is 1.
  In some countries this is a legal requirement for official documents.
  
## 0.4.0

- DatePeriod transformed into an immutable class
- Removed deprecated setter and getter for "startingDate"
- Removed deprecated setter and getter for "endingDate"
- Removed deprecated "getEndDate" method
- Removed deprecated "getFirstExcludedDay" method
- Removed deprecated "getDays" method
- Static constructors have been transformed into factories

## 0.3.4

- Added toYMdString() and parseYMdString()

## 0.3.3

- Sdk 2.2.0 support
- Call to DatePeriod.isInPeriod() was giving error if the date parameter was null. Now returns false.
- Changed the way how the DatePeriod is serialized (toJson). Instead of saving the duration, it is saved the end date in format yyyy-mm-dd
- Added the weekday getter

## 0.3.2

- Sdk 2.1.0 support.
- Some Linter rules applied  
  
## 0.3.1

- Dart 2 support

## 0.3.0

- Initial version
