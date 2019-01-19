// Copyright (c) 2017, Giorgio. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:vy_date/vy_date.dart';

void main() {
  final Date date = Date.now();
  final Date nextDay = date.add(Duration(days: 1));
  final DatePeriod period = DatePeriod(date, nextDay);
  // prints: "Number of days: 2"
  print('Number of days: ${period.inDays}');
}
