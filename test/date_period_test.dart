import 'package:intl/date_symbol_data_local.dart';
import 'package:vy_date/vy_date.dart'
    show Date, DatePeriod, DatePeriodAssembler;
import 'package:test/test.dart';

void main() async {
  await initializeDateFormatting('it_IT', null);
  DatePeriod datePeriod, datePeriod_2;
  DatePeriodAssembler datePeriodAssembler, datePeriodAssembler_2;

  final date = Date(2008, 12, 29);

  group('DatePeriod Creation', () {
    test('Standard constructor', () {
      datePeriodAssembler = DatePeriodAssembler();
      expect(datePeriodAssembler.startDate, isNull);
      expect(datePeriodAssembler.duration, isNull);

      datePeriodAssembler = DatePeriodAssembler(date);
      expect(datePeriodAssembler.startDate, date);
      expect(datePeriodAssembler.duration, isNull);
      expect(datePeriodAssembler.isValid(), isFalse);

      datePeriodAssembler = DatePeriodAssembler(date, Date(2009, 1, 7));
      expect(datePeriodAssembler.startDate, date);
      expect(datePeriodAssembler.duration, Duration(days: 10));
      expect(datePeriodAssembler.endDate, Date(2009, 1, 7));
      expect(datePeriodAssembler.isValid(), isTrue);
      expect(datePeriodAssembler.exclusiveEndDate, Date(2009, 1, 8));

      datePeriod = DatePeriod(date, Date(2009, 1, 7));
      expect(datePeriod.startDate, date);
      expect(datePeriod.duration, Duration(days: 10));
      expect(datePeriod.endDate, Date(2009, 1, 7));
      expect(datePeriod.exclusiveEndDate, Date(2009, 1, 8));

      datePeriod = DatePeriodAssembler(date, Date(2009, 1, 7)).generate();
      expect(datePeriod.startDate, date);
      expect(datePeriod.duration, Duration(days: 10));
      expect(datePeriod.endDate, Date(2009, 1, 7));
      expect(datePeriod.exclusiveEndDate, Date(2009, 1, 8));
    });

    test('ByDuration constructor', () {
      datePeriod = DatePeriod.byDuration(date, Duration(days: 10));
      expect(datePeriod.startDate, date);
      expect(datePeriod.duration, Duration(days: 10));
      expect(datePeriod.exclusiveEndDate, Date(2009, 1, 8));
      expect(datePeriod.endDate, Date(2009, 1, 7));
    });
  });

  group('Setting values', () {
    test('Setting startDate', () {
      datePeriodAssembler = DatePeriodAssembler()..startDate = date;
      expect(datePeriodAssembler.duration, isNull);
      expect(datePeriodAssembler.startDate, date);
      expect(datePeriodAssembler.isValid(), isFalse);

      datePeriodAssembler.duration = Duration(days: 10);
      expect(datePeriodAssembler.exclusiveEndDate, Date(2009, 1, 8));

      expect(() {
        datePeriodAssembler.startDate = Date(2009, 1, 10);
      }, throwsArgumentError);

      datePeriodAssembler.startDate = Date(2009, 1, 1);
      expect(datePeriodAssembler.duration, Duration(days: 7));
      expect(datePeriodAssembler.endDate, Date(2009, 1, 7));
    });

    test('Setting duration', () {
      datePeriodAssembler = DatePeriodAssembler()
        ..duration = Duration(days: 10);
      expect(datePeriodAssembler.startDate, isNull);
      expect(datePeriodAssembler.duration, Duration(days: 10));
      expect(datePeriodAssembler.isValid(), isFalse);

      datePeriodAssembler.startDate = date;
      expect(datePeriodAssembler.exclusiveEndDate, Date(1970, 1, 11));

      expect(() {
        datePeriodAssembler.duration = Duration(days: 0);
      }, throwsArgumentError);
      expect(() {
        datePeriodAssembler.duration = Duration(days: -1);
      }, throwsArgumentError);

      datePeriodAssembler.duration = Duration(days: 3, hours: 23);
      expect(datePeriodAssembler.duration, Duration(days: 3));
      expect(datePeriodAssembler.startDate, date);
      expect(datePeriodAssembler.endDate, Date(2008, 12, 31));
    });

    test('Setting exclusive end date', () {
      datePeriodAssembler = DatePeriodAssembler()
        ..exclusiveEndDate = Date(2009, 1, 8);
      expect(datePeriodAssembler.startDate, null);
      expect(datePeriodAssembler.duration, Duration(hours: 342048));
      expect(datePeriodAssembler.isValid(), isFalse);

      datePeriodAssembler.startDate = date;
      expect(datePeriodAssembler.exclusiveEndDate, Date(2009, 1, 8));
      expect(datePeriodAssembler.startDate, date);
      expect(datePeriodAssembler.duration, Duration(days: 10));

      expect(() {
        datePeriodAssembler.exclusiveEndDate = Date(2008, 1, 1);
      }, throwsArgumentError);

      datePeriodAssembler.duration = Duration(days: 3);
      expect(datePeriodAssembler.duration, Duration(days: 3));
      expect(datePeriodAssembler.startDate, date);
      expect(datePeriodAssembler.endDate, Date(2008, 12, 31));
    });

    test('Setting end date', () {
      datePeriodAssembler = DatePeriodAssembler()..endDate = Date(2009, 1, 7);
      expect(datePeriodAssembler.startDate, null);
      expect(datePeriodAssembler.duration, Duration(hours: 342048));
      expect(datePeriodAssembler.isValid(), isFalse);

      datePeriodAssembler.startDate = date;
      expect(datePeriodAssembler.endDate, Date(2009, 1, 7));
      expect(datePeriodAssembler.startDate, date);
      expect(datePeriodAssembler.duration, Duration(days: 10));

      expect(() {
        datePeriodAssembler.endDate = Date(2008, 1, 1);
      }, throwsArgumentError);

      datePeriodAssembler.duration = Duration(days: 3);
      expect(datePeriodAssembler.duration, Duration(days: 3));
      expect(datePeriodAssembler.startDate, date);
      expect(datePeriodAssembler.exclusiveEndDate, Date(2009, 1, 1));
    });
  });

  group('Checking methods', () {
    final datePeriod = DatePeriod(date, Date(2009, 1, 7));
    datePeriodAssembler = DatePeriodAssembler()..initFrom(datePeriod);
    datePeriodAssembler_2 = DatePeriodAssembler(date, null);

    final jsonMap = <String, String>{
      DatePeriod.fieldStartDate: '2008-12-29',
      DatePeriod.fieldEndDate: '2009-01-07'
    };
    final jsonMap2 = <String, dynamic>{
      DatePeriod.fieldStartDate: '2008-12-29',
      DatePeriod.fieldEndDate: '2008-12-31'
    };
    const encodedString = '{"startDate":"2008-12-29","endDate":"2009-01-07"}';
    const encodedString_2 = '{"startDate":"2008-12-29","endDate":"2008-12-31"}';

    test('to String', () {
      expect('$datePeriod', 'From 2008-12-29 to 2009-01-07 ');
      expect('$datePeriodAssembler_2', 'From 2008-12-29 to null ');
    });

    test('toJson', () {
      expect(datePeriod.toJson(), jsonMap);
    });

    test('initFrom', () {
      var dp = DatePeriodAssembler();
      dp.initFrom(datePeriod);
      expect(dp.generate(), datePeriod);
      dp = DatePeriodAssembler();
      dp.initFrom((datePeriodAssembler_2.duplicate()
            ..endDate = Date(2009, 01, 01))
          .generate());
      expect(dp != datePeriodAssembler_2, isTrue);
    });

    test('newFromMap', () {
      var dp = DatePeriodAssembler.newFromMap(jsonMap);
      expect(dp.generate(), datePeriod);
      dp = DatePeriodAssembler.newFromMap(jsonMap2);
      expect(dp,
          (datePeriodAssembler_2.duplicate()..endDate = Date(2008, 12, 31)));
    });

    test('duplicate', () {
      expect(datePeriod.duplicate(), datePeriod);
      var dp = DatePeriodAssembler()..initFrom(datePeriod.duplicate());
      expect(dp.generate(), datePeriod);
      dp = datePeriodAssembler.duplicate();
      expect(dp, datePeriodAssembler);
      dp = datePeriodAssembler_2.duplicate();
      expect(dp, datePeriodAssembler_2);
    });

    test('encode', () {
      expect(datePeriod.encode(), encodedString);
    });

    test('revive', () {
      var dp = DatePeriod.revive(encodedString);
      expect(dp, datePeriod);
      datePeriod_2 = DatePeriod(Date(2008, 12, 29), Date(2008, 12, 31));
      dp = DatePeriod.revive(encodedString_2);
      expect(dp, datePeriod_2);
    });

    test('isValid', () {
      expect(datePeriodAssembler_2.isValid(), isFalse);
    });

    test('inDays', () {
      expect(datePeriod.inDays, 10);
    });

    test('isInPeriod', () {
      expect(datePeriod.isInPeriod(date), isTrue);
      expect(datePeriod.isInPeriod(datePeriod.endDate), isTrue);
      expect(datePeriod.isInPeriod(datePeriod.exclusiveEndDate), isFalse);
      expect(datePeriod.isInPeriod(Date(2009, 1, 1)), isTrue);
      expect(datePeriod.isInPeriod(Date(2007, 12, 31)), isFalse);
      expect(datePeriod.isInPeriod(Date(2009, 12, 31)), isFalse);
    });

    test('CompareTo', () {
      var dp = DatePeriodAssembler()..initFrom(datePeriod);
      expect(datePeriod.compareTo(dp.generate()), 0);
      dp.exclusiveEndDate = Date(2009, 1, 1);
      expect(datePeriod.compareTo(dp.generate()), 1);
      dp.exclusiveEndDate = Date(2009, 1, 31);
      expect(datePeriod.compareTo(dp.generate()), -1);
      dp.startDate = Date(2008, 1, 31);
      expect(datePeriod.compareTo(dp.generate()), 1);
      dp.startDate = Date(2008, 12, 31);
      expect(datePeriod.compareTo(dp.generate()), -1);
      dp = datePeriodAssembler_2.duplicate();
      //expect(datePeriod_2.compareTo(dp.generate()), 0);
      expect(() => dp.generate(), throwsArgumentError);
      dp.endDate = Date(2009);
      expect(datePeriod.compareTo(dp.generate()), 1);
    });

    test('Comparison Operators', () {
      var dp = DatePeriodAssembler()..initFrom(datePeriod);
      expect(datePeriod >= dp.generate(), isTrue);
      dp.exclusiveEndDate = Date(2009, 1, 1);
      expect(datePeriod > dp.generate(), isTrue);
      dp.exclusiveEndDate = Date(2009, 1, 31);
      expect(datePeriod < dp.generate(), isTrue);
      dp.startDate = Date(2008, 1, 31);
      expect(datePeriod < dp.generate(), isFalse);
      dp.startDate = Date(2008, 12, 31);
      expect(datePeriod >= dp.generate(), isFalse);
      dp = datePeriodAssembler_2.duplicate();
      //expect(datePeriod_2 >= dp.generate(), isTrue);
      expect(() => dp.generate(), throwsArgumentError);
      dp.endDate = Date(2009);
      expect(datePeriod >= dp.generate(), isTrue);
    });

    test('Clearing start date', () {
      final dp = DatePeriodAssembler(Date(2008, 1, 1), Date(2009, 1, 7));
      dp.startDate = null;
      expect(dp.endDate, Date(2009, 1, 7));
      expect(dp.duration, Duration(hours: 342048));
      dp.startDate = Date(2009, 1, 1);
      expect(dp.endDate, Date(2009, 1, 7));
      Duration saveDuration;
      saveDuration = dp.duration!;
      dp.endDate = null;
      dp.endDate = Date(2009, 1, 7);
      expect(dp.duration, saveDuration);
    });

    test('Split', () {
      final dp = DatePeriod(Date(2015, 07, 09), Date(2018, 3, 14));
      List<DatePeriod> periods;
      periods = dp.splitByEndDate(Date(2010, 06, 30));
      expect(periods.length, 3);
      expect(periods[0].startDate, dp.startDate);
      expect(periods[1].startDate, Date(2016, 7, 1));
      expect(periods[2].startDate, Date(2017, 7, 1));
      expect(periods[0].endDate, Date(2016, 6, 30));
      expect(periods[1].endDate, Date(2017, 6, 30));
      expect(periods[2].endDate, dp.endDate);
    });

    test('Split', () {
      final dp = DatePeriod(Date(2015, 07, 09), Date(2018, 07, 09));
      List<DatePeriod> periods;
      periods = dp.splitByEndDate(Date(2010, 06, 30));
      expect(periods.last, DatePeriod(Date(2018, 07), Date(2018, 07, 09)));
    });

    test('Split single', () {
      final dp = DatePeriod(Date(2015, 07, 09), Date(2016, 3, 14));
      List<DatePeriod> periods;
      periods = dp.splitByEndDate(Date(2010, 06, 30));
      expect(periods.length, 1);
      expect(periods[0].startDate, dp.startDate);
      expect(periods[0].endDate, dp.endDate);
    });

    test('Split same enda date', () {
      final dp = DatePeriod(Date(2015, 07, 09), Date(2017, 06, 30));
      List<DatePeriod> periods;
      periods = dp.splitByEndDate(Date(2010, 06, 30));
      expect(periods.length, 2);
      expect(periods[0].startDate, dp.startDate);
      expect(periods[1].startDate, Date(2016, 07, 1));
      expect(periods[0].endDate, Date(2016, 06, 30));
      expect(periods[1].endDate, dp.endDate);
    });
  });

  group('Formatting', () {
    final datePeriod = DatePeriod(date, Date(2009, 1, 7));

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
