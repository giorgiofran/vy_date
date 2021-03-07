import 'package:intl/date_symbol_data_local.dart' show initializeDateFormatting;

import 'package:vy_date/vy_date.dart';

void main() async {
  var date = Date.now();
  final nextDay = date.add(Duration(days: 1));
  final period = DatePeriodAssembler(date, nextDay);
  // prints: "Number of days: 2"
  print('Number of days: ${period.inDays}');
  // print "Difference in days: 1"
  print('Difference in days: ${nextDay.difference(date).inDays}');
  // prints "Date is before nextDay: true"
  print('Date is before nextDay: ${date.isBefore(nextDay)}');
  // print "Date is after nextDay: false"
  print('Date is after nextDay: ${date.isAfter(nextDay)}');

  date = Date(2020, 05, 12);

  // print "toString(): 2020-05-12"
  print('toString(): $date');
  // print "Month (May): 5"
  print('Month (May): ${date.month}');

  /// before using toYMdString() we have to initialize intl
  try {
    print('Date in YMD format: ${date.toYMdString('en_us')}');
  } catch (e) {
    print(e);
  }

  // this must be done just once for the whole application for each locale used
  await initializeDateFormatting('en_us');
  // print "Date in YMd format: 5/12/2020"
  print('Date in YMD format: ${date.toYMdString('en_us')}');

  /// intl initialization (as above) must have been performed before
  /// calling toYMMMMdString()
  // print "Date in YMMMMd format: May 12, 2020"
  print('Date in YMMMMd format: ${date.toYMMMMdString('en_us')}');
}
