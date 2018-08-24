// Copyright (c) 2017, Giorgio. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:vy_date/vy_date.dart';

main() {
  Date date = new Date.now();
  Date nextDay = date.add(new Duration(days: 1));
  DatePeriod period = new DatePeriod(date, nextDay);
  // prints: "Number of days: 2"
  print('Number of days: ${period.inDays}');
}
