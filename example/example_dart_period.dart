/// Copyright © 2016 Vidya sas. All rights reserved.
/// Created by Giorgio on 22/12/2019.
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
