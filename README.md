# vy_date

Simple utilities for managing dates and periods.

### Date class

The Date class simply wraps the DateTime one.
I believe that it is easier to manage dates this way because it frees you 
from the hassle of the time zones 
and prevents you doing the following potentially dangerous moves:
- Involuntarily set minutes or seconds or so on. 
This can lead to problems when comparing dates
- Have to work with dates from different time zones or mixed with UTC ones.

Pluses:
- You can be sure that the difference in days is always correct.
- Have some easy to use functions for formatting
- Json formatting

Instances can be serialized with Json, in this case they are sent as a `String`
with the date in format "YYYY-MM-DD".

Technically speaking, the date is transformed int an UTC DateTime instance.
During insertion all references to time info are lost.

There are a couple of formatting functions and their counterparts for 
parsing the result. These methods **require** `Intl` to be initialized.
Inside your application you have to import the `Intl` package:

`import 'package:intl/date_symbol_data_local.dart';`

and you have to initialize the locale you'll gonna use with the statement:

`await initializeDateFormatting('en_US', null);`

This is needed only once in the whole application, 
before using the formatting methods for the rquired locale, otherwise a 
`LocaleDataException` will be thrown

## Usage

A simple usage example:

    import 'package:vy_date/vy_date.dart';

    main() {
      Date date = Date.now();
    }

### DatePeriod class

This class allows to manage a period between two dates.
It is immutable, and has a companion class that allows to manage partial
data before generating a correct instance of DatePeriod.
This companion class is called DatePeriodAssembler and follows the logic 
of the Builder classes. I could have used the name DatePeriodBuilder,
but I did not want to confuse how the class behave with 
those of the `built_value` package. 
The logic is + or - the same, but there is a difference: 
the data class (DatePeriod in this case) is not aware of the existence 
of an helper method, and could even be used alone, while the built_value
package generated classes are tightly coupled together.

The class is comparable, the comparision is made first testing the start date
and then, if equal, testing the period duration.

The DatePeriod class does not accept negative periods (i.e. those with the end
period date before in time of the start period one).

You can even initialize the period with null values (even if this is discouraged).
If a null start date is receive the conventional date 1970-01-01 is used,
if the end date (or duration, depending on the constructor) is null,
a period of one day is used.

The class is normally managed with initial and ending dates inclusive, 
but you can extract the exclusive end date with the appropriate getter if needed.

When converted to Json string the class is saved as Map containing the 
two dates into the above (see Date class) mentioned format. 

## Usage

A simple usage example:

    import 'package:vy_date/vy_date.dart';

    void main() {
      DatePeriod period = DatePeriod(Date(2010, 1, 1), Date(2010, 1, 31));
      // print "31"
      print(period.inDays);
      
      DatePeriodAssembler periodAssembler = DatePeriodAssembler()
        ..startDate = Date(2010, 1, 1)
        ..exclusiveEndDate = Date(2010, 2, 1);
      // print "0"
      print(periodAssembler.generate().compareTo(period)); 
    }

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/giorgiofran/vy_date/issues

[license](https://github.com/giorgiofran/vy_date/blob/master/LICENSE).
