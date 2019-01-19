// Copyright (c) 2017, Giorgio. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:intl/date_symbol_data_local.dart';
import 'package:vy_date/vy_date.dart' show Date;
import 'package:test/test.dart';

void main() async {
  await initializeDateFormatting('it_IT', null);

  group('Date Creation', () {
    test('Standard constructor', () {
      final Date dt = Date(2008, 12, 29);
      final Date dt2 = Date(-15, 01, 29);
      expect(dt.day, 29);
      expect(dt2.year, -15);
      expect(dt2.month, 01);
    });
    test('now', () {
      final Date date = Date.now();
      final DateTime dt = DateTime.now();
      final Date dt2 = Date(2015, 02, 03);
      expect(date.year, dt.year);
      expect(date.month, dt.month);
      expect(date.day, dt.day);
      expect(Date.now().isAfter(dt2), isTrue);
    });
    test('fromDateTime', () {
      final Date date = Date.now();
      final Date date2 = Date.fromDateTime(DateTime.now());
      expect(date, date2);
    });
    test('static - parse', () {
      Date date = Date.parse('2012-02-27');
      expect(date, Date(2012, 02, 27));
      date = Date.parse('2012-02-27 13:27:00');
      expect(date, Date(2012, 02, 27));
      date = Date.parse('20120227 13:27:00');
      expect(date, Date(2012, 02, 27));

      date = Date.parse('20120227T132700');
      expect(date, Date(2012, 02, 27));
      date = Date.parse('20120227');
      expect(date, Date(2012, 02, 27));
      date = Date.parse('+20120227');
      expect(date, Date(2012, 02, 27));
      date = Date.parse('2012-02-27T14Z');
      expect(date, Date(2012, 02, 27));
      date = Date.parse('2012-02-27T14+00:00');
      expect(date, Date(2012, 02, 27));
      date = Date.parse('-123450101 00:00:00 Z');
      expect(date, Date(-12345, 01, 01));
      date = Date.parse('2002-02-27T14:00:00-0500');
      expect(date, Date(2002, 02, 27));
    });
  });

  group('Output', () {
    test('Iso 8601', () {
      final Date dt = Date(2008, 12, 29);
      final Date dt2 = Date(-15, 01, 29);
      expect(dt.toIso8601String(), '2008-12-29');
      expect(dt2.toIso8601String(), '-0015-01-29');
    });
    test('To String', () {
      final Date dt = Date(2008, 12, 29);
      final Date dt2 = Date(-15, 01, 29);
      expect(dt.toString(), '2008-12-29');
      expect(dt2.toString(), '-0015-01-29');
    });
  });

  group('Comparison', () {
    test('equals', () {
      final Date dt = Date(2018, 02, 03);
      //Date dt2 = new Date(2015, 02, 03);
      expect(Date(2018, 02, 03), dt);
    });

    test('CompareTo', () {
      final Date dt = Date(2008, 12, 29);
      final Date dt3 = Date.now();
      final Date dt2 = Date(-15, 01, 29);
      expect(dt3.compareTo(dt), 1);
      expect(dt2.compareTo(dt), -1);
      expect(dt.compareTo(dt), 0);
    });
    test('is Before', () {
      final Date dt = Date(2008, 12, 29);
      final Date dt2 = Date(-15, 01, 29);
      final Date dt3 = Date.now();

      expect(dt.isBefore(dt3), isTrue);
      expect(dt2.isBefore(dt), isTrue);
      expect(dt3.isBefore(dt2), isFalse);
    });
    test('is After', () {
      final Date dt = Date(2008, 12, 29);
      final Date dt2 = Date(-15, 01, 29);
      final Date dt3 = Date.now();

      expect(dt.isAfter(dt3), isFalse);
      expect(dt.isAfter(dt2), isTrue);
      expect(dt3.isAfter(dt2), isTrue);
    });

    test('toJson', () {
      final Date dt = Date(2018, 02, 03);
      expect(dt.toJson(), '2018-02-03');
    });
  });

  group('Formatting', () {
    test('Format to String', () {
      final Date dt = Date(2018, 02, 03);
      expect(dt.toYMMMMdString('en_US'), 'February 3, 2018');
      expect(dt.toYMMMMdString('it_IT'), '3 febbraio 2018');
      expect(dt.toYMMMMdString('te_IN'), '3 ఫిబ్రవరి, 2018');
    });

    test('Parse from String', () {
      final Date dt = Date(2018, 02, 03);
      expect(Date.parseYMMMMdString('3 febbraio 2018', 'it_IT'), dt);
      expect(Date.parseYMMMMdString('February 3, 2018', 'en_US'), dt);
    });
  });
}
