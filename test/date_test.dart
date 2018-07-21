// Copyright (c) 2017, Giorgio. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:intl/date_symbol_data_local.dart';
import 'package:vy_date/vy_date.dart' show Date;
import 'package:test/test.dart';

main() async {
  await initializeDateFormatting('it_IT', null);

  group('Date Creation', () {
    test('Standard constructor', () {
      Date dt = new Date(2008, 12, 29);
      Date dt2 = new Date(-15, 01, 29);
      expect(dt.day, 29);
      expect(dt2.year, -15);
      expect(dt2.month, 01);
    });
    test('now', () {
      Date date = new Date.now();
      DateTime dt = new DateTime.now();
      Date dt2 = new Date(2015, 02, 03);
      expect(date.year, dt.year);
      expect(date.month, dt.month);
      expect(date.day, dt.day);
      expect(new Date.now().isAfter(dt2), isTrue);
    });
    test('fromDateTime', () {
      Date date = new Date.now();
      Date date2 = new Date.fromDateTime(new DateTime.now());
      expect(date, date2);
    });
    test('static - parse', () {
      Date date = Date.parse("2012-02-27");
      expect(date, new Date(2012, 02, 27));
      date = Date.parse("2012-02-27 13:27:00");
      expect(date, new Date(2012, 02, 27));
      date = Date.parse("20120227 13:27:00");
      expect(date, new Date(2012, 02, 27));

      date = Date.parse("20120227T132700");
      expect(date, new Date(2012, 02, 27));
      date = Date.parse("20120227");
      expect(date, new Date(2012, 02, 27));
      date = Date.parse("+20120227");
      expect(date, new Date(2012, 02, 27));
      date = Date.parse("2012-02-27T14Z");
      expect(date, new Date(2012, 02, 27));
      date = Date.parse("2012-02-27T14+00:00");
      expect(date, new Date(2012, 02, 27));
      date = Date.parse("-123450101 00:00:00 Z");
      expect(date, new Date(-12345, 01, 01));
      date = Date.parse("2002-02-27T14:00:00-0500");
      expect(date, new Date(2002, 02, 27));
    });
  });

  group('Output', () {
    test('Iso 8601', () {
      Date dt = new Date(2008, 12, 29);
      Date dt2 = new Date(-15, 01, 29);
      expect(dt.toIso8601String(), '2008-12-29');
      expect(dt2.toIso8601String(), '-0015-01-29');
    });
    test('To String', () {
      Date dt = new Date(2008, 12, 29);
      Date dt2 = new Date(-15, 01, 29);
      expect(dt.toString(), '2008-12-29');
      expect(dt2.toString(), '-0015-01-29');
    });
  });

  group('Comparison', () {
    test('equals', () {
      Date dt = new Date(2018, 02, 03);
      //Date dt2 = new Date(2015, 02, 03);
      expect(new Date(2018, 02, 03), dt);
    });

    test('CompareTo', () {
      Date dt = new Date(2008, 12, 29);
      Date dt3 = new Date.now();
      Date dt2 = new Date(-15, 01, 29);
      expect(dt3.compareTo(dt), 1);
      expect(dt2.compareTo(dt), -1);
      expect(dt.compareTo(dt), 0);
    });
    test('is Before', () {
      Date dt = new Date(2008, 12, 29);
      Date dt2 = new Date(-15, 01, 29);
      Date dt3 = new Date.now();

      expect(dt.isBefore(dt3), isTrue);
      expect(dt2.isBefore(dt), isTrue);
      expect(dt3.isBefore(dt2), isFalse);
    });
    test('is After', () {
      Date dt = new Date(2008, 12, 29);
      Date dt2 = new Date(-15, 01, 29);
      Date dt3 = new Date.now();

      expect(dt.isAfter(dt3), isFalse);
      expect(dt.isAfter(dt2), isTrue);
      expect(dt3.isAfter(dt2), isTrue);
    });

    test('toJson', () {
      Date dt = new Date(2018, 02, 03);
      expect(dt.toJson(), '2018-02-03');
    });
  });

  group('Formatting', () {
    test('Format to String', () {
      Date dt = new Date(2018, 02, 03);
      expect(dt.toYMMMMdString('en_US'), 'February 3, 2018');
      expect(dt.toYMMMMdString('it_IT'), '3 febbraio 2018');
      expect(dt.toYMMMMdString('te_IN'), '3 ఫిబ్రవరి, 2018');
    });

    test('Parse from String', () {
      Date dt = new Date(2018, 02, 03);
      expect(Date.parseYMMMMdString('3 febbraio 2018', 'it_IT'), dt);
      expect(Date.parseYMMMMdString('February 3, 2018', 'en_US'), dt);
    });
  });
}
