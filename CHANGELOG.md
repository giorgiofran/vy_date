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
- Package Intl ^0.16.0 instead of ^0.15.7

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
