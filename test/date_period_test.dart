/// Copyright © 2016 Vidya sas. All rights reserved.
/// Created by Giorgio on 28/04/2017.

import 'package:intl/date_symbol_data_local.dart';
import 'package:vy_date/vy_date.dart' show Date, DatePeriod;
import 'package:test/test.dart';

main() async {
  await initializeDateFormatting('it_IT', null);
  DatePeriod datePeriod, datePeriod_2;
  Date date = new Date(2008, 12, 29);

  group('DatePeriod Creation', () {
    test('Standard constructor', () {
      datePeriod = new DatePeriod();
      expect(datePeriod.startDate, isNull);
      expect(datePeriod.duration, isNull);

      datePeriod = new DatePeriod(date);
      expect(datePeriod.startDate, date);
      expect(datePeriod.duration, isNull);
      expect(datePeriod.isValid(), isFalse);

      datePeriod = new DatePeriod(date, new Date(2009, 1, 7));
      expect(datePeriod.startDate, date);
      expect(datePeriod.duration, new Duration(days: 10));
      expect(datePeriod.endDate, new Date(2009, 1, 7));
      expect(datePeriod.isValid(), isTrue);
      expect(datePeriod.exclusiveEndDate, new Date(2009, 1, 8));
    });

    test('ByDuration constructor', () {
      datePeriod = new DatePeriod.byDuration(date, new Duration(days: 10));
      expect(datePeriod.startDate, date);
      expect(datePeriod.duration, new Duration(days: 10));
      expect(datePeriod.exclusiveEndDate, new Date(2009, 1, 8));
      expect(datePeriod.endDate, new Date(2009, 1, 7));
      expect(datePeriod.isValid(), isTrue);
    });
  });

  group('Setting values', () {
    test('Setting startDate', () {
      datePeriod = new DatePeriod()..startDate = date;
      expect(datePeriod.duration, isNull);
      expect(datePeriod.startDate, date);
      expect(datePeriod.isValid(), isFalse);

      datePeriod.duration = new Duration(days: 10);
      expect(datePeriod.exclusiveEndDate, new Date(2009, 1, 8));

      expect(() {
        datePeriod.startDate = new Date(2009, 1, 10);
      }, throwsArgumentError);

      datePeriod.startDate = new Date(2009, 1, 1);
      expect(datePeriod.duration, new Duration(days: 7));
      expect(datePeriod.endDate, new Date(2009, 1, 7));
    });

    test('Setting duration', () {
      datePeriod = new DatePeriod()..duration = new Duration(days: 10);
      expect(datePeriod.startDate, isNull);
      expect(datePeriod.duration, new Duration(days: 10));
      expect(datePeriod.isValid(), isFalse);

      datePeriod.startDate = date;
      expect(datePeriod.exclusiveEndDate, new Date(1970, 1, 11));

      expect(() {
        datePeriod.duration = new Duration(days: 0);
      }, throwsArgumentError);
      expect(() {
        datePeriod.duration = new Duration(days: -1);
      }, throwsArgumentError);

      datePeriod.duration = new Duration(days: 3, hours: 23);
      expect(datePeriod.duration, new Duration(days: 3));
      expect(datePeriod.startDate, date);
      expect(datePeriod.endDate, new Date(2008, 12, 31));
      //expect(dp_1.endingDate, new Date(1900, 1, 10));
      //expect(dp_1.getFirstExcludedDay(), new Date(1900, 1, 11));
    });

    test('Setting exclusive end date', () {
      datePeriod = new DatePeriod()..exclusiveEndDate = new Date(2009, 1, 8);
      expect(datePeriod.startDate, null);
      expect(datePeriod.duration, new Duration(hours: 342048));
      expect(datePeriod.isValid(), isFalse);

      datePeriod.startDate = date;
      expect(datePeriod.exclusiveEndDate, new Date(2009, 1, 8));
      expect(datePeriod.startDate, date);
      expect(datePeriod.duration, new Duration(days: 10));

      expect(() {
        datePeriod.exclusiveEndDate = new Date(2008, 1, 1);
      }, throwsArgumentError);

      datePeriod.duration = new Duration(days: 3);
      expect(datePeriod.duration, new Duration(days: 3));
      expect(datePeriod.startDate, date);
      expect(datePeriod.endDate, new Date(2008, 12, 31));
    });

    test('Setting end date', () {
      datePeriod = new DatePeriod()..endDate = new Date(2009, 1, 7);
      expect(datePeriod.startDate, null);
      expect(datePeriod.duration, new Duration(hours: 342048));
      expect(datePeriod.isValid(), isFalse);

      datePeriod.startDate = date;
      expect(datePeriod.endDate, new Date(2009, 1, 7));
      expect(datePeriod.startDate, date);
      expect(datePeriod.duration, new Duration(days: 10));

      expect(() {
        datePeriod.endDate = new Date(2008, 1, 1);
      }, throwsArgumentError);

      datePeriod.duration = new Duration(days: 3);
      expect(datePeriod.duration, new Duration(days: 3));
      expect(datePeriod.startDate, date);
      expect(datePeriod.exclusiveEndDate, new Date(2009, 1, 1));
    });
  });

  group('Checking methods', () {
    DatePeriod datePeriod = new DatePeriod(date, new Date(2009, 1, 7));
    datePeriod_2 = new DatePeriod(date, null);

    Map<String, dynamic> jsonMap = {
      DatePeriod.fieldStartDate: '2008-12-29',
      DatePeriod.fieldDuration: '864000000'
    };
    Map<String, dynamic> jsonMap_2 = {
      DatePeriod.fieldStartDate: '2008-12-29',
      DatePeriod.fieldDuration: null
    };
    String encodedString = '{"startDate":"2008-12-29","duration":"864000000"}';
    String encodedString_2 = '{"startDate":"2008-12-29","duration":null}';

    test('to String', () {
      expect(datePeriod.toString(), 'From 2008-12-29 to 2009-01-07 ');
      expect(datePeriod_2.toString(), 'From 2008-12-29 to null ');
    });

    test('toJson', () {
      expect(datePeriod.toJson(), jsonMap);
      expect(datePeriod_2.toJson(), jsonMap_2);
    });

    test('initFrom', () {
      DatePeriod dp = new DatePeriod();
      dp.initFrom(datePeriod);
      expect(dp, datePeriod);
      dp = new DatePeriod();
      dp.initFrom(datePeriod_2);
      expect(dp, datePeriod_2);
    });

    test('newFromMap', () {
      DatePeriod dp = DatePeriod.newFromMap(jsonMap);
      expect(dp, datePeriod);
      dp = DatePeriod.newFromMap(jsonMap_2);
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
      expect(datePeriod.isInPeriod(new Date(2009, 1, 1)), isTrue);
      expect(datePeriod.isInPeriod(new Date(2007, 12, 31)), isFalse);
      expect(datePeriod.isInPeriod(new Date(2009, 12, 31)), isFalse);
      expect(datePeriod_2.isInPeriod(date), isFalse);
    });

    test('CompareTo', () {
      DatePeriod dp = datePeriod.duplicate();
      expect(datePeriod.compareTo(dp), 0);
      dp.exclusiveEndDate = new Date(2009, 1, 1);
      expect(datePeriod.compareTo(dp), 1);
      dp.exclusiveEndDate = new Date(2009, 1, 31);
      expect(datePeriod.compareTo(dp), -1);
      dp.startDate = new Date(2008, 1, 31);
      expect(datePeriod.compareTo(dp), 1);
      dp.startDate = new Date(2008, 12, 31);
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
      dp.exclusiveEndDate = new Date(2009, 1, 1);
      expect(datePeriod > dp, isTrue);
      dp.exclusiveEndDate = new Date(2009, 1, 31);
      expect(datePeriod < dp, isTrue);
      dp.startDate = new Date(2008, 1, 31);
      expect(datePeriod < dp, isFalse);
      dp.startDate = new Date(2008, 12, 31);
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
      DatePeriod dp =
          new DatePeriod(new Date(2008, 1, 1), new Date(2009, 1, 7));
      dp.startDate = null;
      expect(dp.endDate, new Date(2009, 1, 7));
      expect(dp.duration, new Duration(hours: 342048));
      dp.startDate = new Date(2009, 1, 1);
      expect(dp.endDate, new Date(2009, 1, 7));
      Duration saveDuration = dp.duration;
      dp.endDate = null;
      dp.endDate = new Date(2009, 1, 7);
      expect(dp.duration, saveDuration);
    });

    test('Split', () {
      DatePeriod dp =
          new DatePeriod(new Date(2015, 07, 09), new Date(2018, 3, 14));
      List<DatePeriod> periods = dp.splitByEndDate(new Date(2010, 06, 30));
      expect(periods.length, 3);
      expect(periods[0].startDate, dp.startDate);
      expect(periods[1].startDate, new Date(2016, 7, 1));
      expect(periods[2].startDate, new Date(2017, 7, 1));
      expect(periods[0].endDate, new Date(2016, 6, 30));
      expect(periods[1].endDate, new Date(2017, 6, 30));
      expect(periods[2].endDate, dp.endDate);
    });

    test('Split invalid', () {
      DatePeriod dp = new DatePeriod(new Date(2015, 07, 09), null);
      List<DatePeriod> periods = dp.splitByEndDate(new Date(2010, 06, 30));
      expect(periods, isNull);
    });

    test('Split single', () {
      DatePeriod dp =
          new DatePeriod(new Date(2015, 07, 09), new Date(2016, 3, 14));
      List<DatePeriod> periods = dp.splitByEndDate(new Date(2010, 06, 30));
      expect(periods.length, 1);
      expect(periods[0].startDate, dp.startDate);
      expect(periods[0].endDate, dp.endDate);
    });

    test('Split same enda date', () {
      DatePeriod dp =
      new DatePeriod(new Date(2015, 07, 09), new Date(2017, 06, 30));
      List<DatePeriod> periods = dp.splitByEndDate(new Date(2010, 06, 30));
      expect(periods.length, 2);
      expect(periods[0].startDate, dp.startDate);
      expect(periods[1].startDate, new Date(2016, 07, 1));
      expect(periods[0].endDate, new Date(2016, 06, 30));
      expect(periods[1].endDate, dp.endDate);
    });
  });

  group('Formatting', () {
    DatePeriod datePeriod = new DatePeriod(date, new Date(2009, 1, 7));

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
