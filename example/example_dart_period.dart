/// Copyright © 2018 Giorgio Franceschetti. All rights reserved.

import 'package:vy_date/vy_date.dart';

void main() {
  var period = DatePeriod(Date(2010, 1, 1), Date(2010, 1, 31));
  // print "31"
  print(period.inDays);
  var periodAssembler = DatePeriodAssembler()
    ..startDate = Date(2010, 1, 1)
    ..exclusiveEndDate = Date(2010, 2, 1);
  // print "0"
  print(periodAssembler.generate().compareTo(period));
}
