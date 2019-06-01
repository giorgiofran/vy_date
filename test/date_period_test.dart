/// Copyright © 2016 Vidya sas. All rights reserved.
/// Created by Giorgio on 28/04/2017.

import 'package:intl/date_symbol_data_local.dart';
import 'package:vy_date/vy_date.dart' show Date, DatePeriod;
import 'package:test/test.dart';

void main() async {
  await initializeDateFormatting('it_IT', null);
  DatePeriod datePeriod, datePeriod_2;
  final Date date = Date(2008, 12, 29);

  group('DatePeriod Creation', () {
    test('Standard constructor', () {
      datePeriod = DatePeriod();
      expect(datePeriod.startDate, isNull);
      expect(datePeriod.duration, isNull);

      datePeriod = DatePeriod(date);
      expect(datePeriod.startDate, date);
      expect(datePeriod.duration, isNull);
      expect(datePeriod.isValid(), isFalse);

      datePeriod = DatePeriod(date, Date(2009, 1, 7));
      expect(datePeriod.startDate, date);
      expect(datePeriod.duration, Duration(days: 10));
      expect(datePeriod.endDate, Date(2009, 1, 7));
      expect(datePeriod.isValid(), isTrue);
      expect(datePeriod.exclusiveEndDate, Date(2009, 1, 8));
    });

    test('ByDuration constructor', () {
      datePeriod = DatePeriod.byDuration(date, Duration(days: 10));
      expect(datePeriod.startDate, date);
      expect(datePeriod.duration, Duration(days: 10));
      expect(datePeriod.exclusiveEndDate, Date(2009, 1, 8));
      expect(datePeriod.endDate, Date(2009, 1, 7));
      expect(datePeriod.isValid(), isTrue);
    });
  });

  group('Setting values', () {
    test('Setting startDate', () {
      datePeriod = DatePeriod()..startDate = date;
      expect(datePeriod.duration, isNull);
      expect(datePeriod.startDate, date);
      expect(datePeriod.isValid(), isFalse);

      datePeriod.duration = Duration(days: 10);
      expect(datePeriod.exclusiveEndDate, Date(2009, 1, 8));

      expect(() {
        datePeriod.startDate = Date(2009, 1, 10);
      }, throwsArgumentError);

      datePeriod.startDate = Date(2009, 1, 1);
      expect(datePeriod.duration, Duration(days: 7));
      expect(datePeriod.endDate, Date(2009, 1, 7));
    });

    test('Setting duration', () {
      datePeriod = DatePeriod()..duration = Duration(days: 10);
      expect(datePeriod.startDate, isNull);
      expect(datePeriod.duration, Duration(days: 10));
      expect(datePeriod.isValid(), isFalse);

      datePeriod.startDate = date;
      expect(datePeriod.exclusiveEndDate, Date(1970, 1, 11));

      expect(() {
        datePeriod.duration = Duration(days: 0);
      }, throwsArgumentError);
      expect(() {
        datePeriod.duration = Duration(days: -1);
      }, throwsArgumentError);

      datePeriod.duration = Duration(days: 3, hours: 23);
      expect(datePeriod.duration, Duration(days: 3));
      expect(datePeriod.startDate, date);
      expect(datePeriod.endDate, Date(2008, 12, 31));
      //expect(dp_1.endingDate, new Date(1900, 1, 10));
      //expect(dp_1.getFirstExcludedDay(), new Date(1900, 1, 11));
    });

    test('Setting exclusive end date', () {
      datePeriod = DatePeriod()..exclusiveEndDate = Date(2009, 1, 8);
      expect(datePeriod.startDate, null);
      expect(datePeriod.duration, Duration(hours: 342048));
      expect(datePeriod.isValid(), isFalse);

      datePeriod.startDate = date;
      expect(datePeriod.exclusiveEndDate, Date(2009, 1, 8));
      expect(datePeriod.startDate, date);
      expect(datePeriod.duration, Duration(days: 10));

      expect(() {
        datePeriod.exclusiveEndDate = Date(2008, 1, 1);
      }, throwsArgumentError);

      datePeriod.duration = Duration(days: 3);
      expect(datePeriod.duration, Duration(days: 3));
      expect(datePeriod.startDate, date);
      expect(datePeriod.endDate, Date(2008, 12, 31));
    });

    test('Setting end date', () {
      datePeriod = DatePeriod()..endDate = Date(2009, 1, 7);
      expect(datePeriod.startDate, null);
      expect(datePeriod.duration, Duration(hours: 342048));
      expect(datePeriod.isValid(), isFalse);

      datePeriod.startDate = date;
      expect(datePeriod.endDate, Date(2009, 1, 7));
      expect(datePeriod.startDate, date);
      expect(datePeriod.duration, Duration(days: 10));

      expect(() {
        datePeriod.endDate = Date(2008, 1, 1);
      }, throwsArgumentError);

      datePeriod.duration = Duration(days: 3);
      expect(datePeriod.duration, Duration(days: 3));
      expect(datePeriod.startDate, date);
      expect(datePeriod.exclusiveEndDate, Date(2009, 1, 1));
    });
  });

  group('Checking methods', () {
    final DatePeriod datePeriod = DatePeriod(date, Date(2009, 1, 7));
    datePeriod_2 = DatePeriod(date, null);

    final Map<String, dynamic> jsonMap = {
      DatePeriod.fieldStartDate: '2008-12-29',
      DatePeriod.fieldEndDate: '2009-01-07'
    };
    final Map<String, dynamic> jsonMap2 = {
      DatePeriod.fieldStartDate: '2008-12-29',
      DatePeriod.fieldEndDate: null
    };
    const String encodedString =
        '{"startDate":"2008-12-29","endDate":"2009-01-07"}';
    const String encodedString_2 = '{"startDate":"2008-12-29","endDate":null}';

    test('to String', () {
      expect(datePeriod.toString(), 'From 2008-12-29 to 2009-01-07 ');
      expect(datePeriod_2.toString(), 'From 2008-12-29 to null ');
    });

    test('toJson', () {
      expect(datePeriod.toJson(), jsonMap);
      expect(datePeriod_2.toJson(), jsonMap2);
    });

    test('initFrom', () {
      DatePeriod dp = DatePeriod();
      dp.initFrom(datePeriod);
      expect(dp, datePeriod);
      dp = DatePeriod();
      dp.initFrom(datePeriod_2);
      expect(dp, datePeriod_2);
    });

    test('newFromMap', () {
      DatePeriod dp = DatePeriod.newFromMap(jsonMap);
      expect(dp, datePeriod);
      dp = DatePeriod.newFromMap(jsonMap2);
      expect(dp, datePeriod_2);
    });

    test('duplicate', () {
      DatePeriod dp = datePeriod.duplicate();
      expect(dp, datePeriod);
      dp = datePeriod_2.duplicate();
      expect(dp, datePeriod_2);
    });

    test('encode', () {
      expect(datePeriod.encode(), encodedString);
      expect(datePeriod_2.encode(), encodedString_2);
    });

    test('revive', () {
      DatePeriod dp = DatePeriod.revive(encodedString);
      expect(dp, datePeriod);
      dp = DatePeriod.revive(encodedString_2);
      expect(dp, datePeriod_2);
    });

    test('isValid', () {
      expect(datePeriod.isValid(), isTrue);
      expect(datePeriod_2.isValid(), isFalse);
    });

    test('inDays', () {
      expect(datePeriod.inDays, 10);
      expect(datePeriod_2.inDays, isNull);
    });

    test('isInPeriod', () {
      expect(datePeriod.isInPeriod(date), isTrue);
      expect(datePeriod.isInPeriod(datePeriod.endDate), isTrue);
      expect(datePeriod.isInPeriod(datePeriod.exclusiveEndDate), isFalse);
      expect(datePeriod.isInPeriod(Date(2009, 1, 1)), isTrue);
      expect(datePeriod.isInPeriod(Date(2007, 12, 31)), isFalse);
      expect(datePeriod.isInPeriod(Date(2009, 12, 31)), isFalse);
      expect(datePeriod_2.isInPeriod(date), isFalse);
    });

    test('CompareTo', () {
      DatePeriod dp = datePeriod.duplicate();
      expect(datePeriod.compareTo(dp), 0);
      dp.exclusiveEndDate = Date(2009, 1, 1);
      expect(datePeriod.compareTo(dp), 1);
      dp.exclusiveEndDate = Date(2009, 1, 31);
      expect(datePeriod.compareTo(dp), -1);
      dp.startDate = Date(2008, 1, 31);
      expect(datePeriod.compareTo(dp), 1);
      dp.startDate = Date(2008, 12, 31);
      expect(datePeriod.compareTo(dp), -1);
      dp = datePeriod_2.duplicate();
      expect(() {
        datePeriod_2.compareTo(dp);
      }, throwsStateError);
      expect(() {
        datePeriod.compareTo(dp);
      }, throwsArgumentError);
    });

    test('Comparison Operators', () {
      DatePeriod dp = datePeriod.duplicate();
      expect(datePeriod >= dp, isTrue);
      dp.exclusiveEndDate = Date(2009, 1, 1);
      expect(datePeriod > dp, isTrue);
      dp.exclusiveEndDate = Date(2009, 1, 31);
      expect(datePeriod < dp, isTrue);
      dp.startDate = Date(2008, 1, 31);
      expect(datePeriod < dp, isFalse);
      dp.startDate = Date(2008, 12, 31);
      expect(datePeriod >= dp, isFalse);
      dp = datePeriod_2.duplicate();
      expect(() {
        datePeriod_2 >= dp;
      }, throwsStateError);
      expect(() {
        datePeriod >= dp;
      }, throwsArgumentError);
    });

    test('Clearing start date', () {
      final DatePeriod dp = DatePeriod(Date(2008, 1, 1), Date(2009, 1, 7));
      dp.startDate = null;
      expect(dp.endDate, Date(2009, 1, 7));
      expect(dp.duration, Duration(hours: 342048));
      dp.startDate = Date(2009, 1, 1);
      expect(dp.endDate, Date(2009, 1, 7));
      final Duration saveDuration = dp.duration;
      dp.endDate = null;
      dp.endDate = Date(2009, 1, 7);
      expect(dp.duration, saveDuration);
    });

    test('Split', () {
      final DatePeriod dp = DatePeriod(Date(2015, 07, 09), Date(2018, 3, 14));
      final List<DatePeriod> periods = dp.splitByEndDate(Date(2010, 06, 30));
      expect(periods.length, 3);
      expect(periods[0].startDate, dp.startDate);
      expect(periods[1].startDate, Date(2016, 7, 1));
      expect(periods[2].startDate, Date(2017, 7, 1));
      expect(periods[0].endDate, Date(2016, 6, 30));
      expect(periods[1].endDate, Date(2017, 6, 30));
      expect(periods[2].endDate, dp.endDate);
    });

    test('Split invalid', () {
      final DatePeriod dp = DatePeriod(Date(2015, 07, 09), null);
      final List<DatePeriod> periods = dp.splitByEndDate(Date(2010, 06, 30));
      expect(periods, isNull);
    });

    test('Split single', () {
      final DatePeriod dp = DatePeriod(Date(2015, 07, 09), Date(2016, 3, 14));
      final List<DatePeriod> periods = dp.splitByEndDate(Date(2010, 06, 30));
      expect(periods.length, 1);
      expect(periods[0].startDate, dp.startDate);
      expect(periods[0].endDate, dp.endDate);
    });

    test('Split same enda date', () {
      final DatePeriod dp = DatePeriod(Date(2015, 07, 09), Date(2017, 06, 30));
      final List<DatePeriod> periods = dp.splitByEndDate(Date(2010, 06, 30));
      expect(periods.length, 2);
      expect(periods[0].startDate, dp.startDate);
      expect(periods[1].startDate, Date(2016, 07, 1));
      expect(periods[0].endDate, Date(2016, 06, 30));
      expect(periods[1].endDate, dp.endDate);
    });
  });

  group('Formatting', () {
    final DatePeriod datePeriod = DatePeriod(date, Date(2009, 1, 7));

    test('Format to String', () {
      expect(datePeriod.toYMMMMdString('en_US'),
          'December 29, 2008 ➖ January 7, 2009');
      expect(datePeriod.toYMMMMdString('it_IT'),
          '29 dicembre 2008 ➖ 7 gennaio 2009');
      expect(datePeriod.toYMMMMdString('te_IN'),
          '29 డిసెంబర్, 2008 ➖ 7 జనవరి, 2009');
    });

    test('Parse from String', () {
      expect(
          DatePeriod.parseYMMMMdString(
              '29 dicembre 2008 ➖ 7 gennaio 2009', 'it_IT'),
          datePeriod);
      expect(
          DatePeriod.parseYMMMMdString(
              'December 29, 2008 ➖ January 7, 2009', 'en_US'),
          datePeriod);
      expect(
          DatePeriod.parseYMMMMdString(
              '29 డిసెంబర్, 2008 ➖ 7 జనవరి, 2009', 'te_IN'),
          datePeriod);
    });
  });
}
