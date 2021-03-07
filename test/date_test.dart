import 'package:intl/date_symbol_data_local.dart';
import 'package:vy_date/vy_date.dart' show Date;
import 'package:test/test.dart';

void main() async {
  await initializeDateFormatting('it_IT', null);

  group('Date Creation', () {
    test('Standard constructor', () {
      final dt = Date(2008, 12, 29);
      final dt2 = Date(-15, 01, 29);
      expect(dt.day, 29);
      expect(dt2.year, -15);
      expect(dt2.month, 01);
    });
    test('now', () {
      final date = Date.now();
      final dt = DateTime.now();
      final dt2 = Date(2015, 02, 03);
      expect(date.year, dt.year);
      expect(date.month, dt.month);
      expect(date.day, dt.day);
      expect(Date.now().isAfter(dt2), isTrue);
    });
    test('fromDateTime', () {
      final date = Date.now();
      final date2 = Date.fromDateTime(DateTime.now());
      expect(date, date2);
    });
    test('static - parse', () {
      var date = Date.parse('2012-02-27');
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
      final dt = Date(2008, 12, 29);
      final dt2 = Date(-15, 01, 29);
      expect(dt.toIso8601String(), '2008-12-29');
      expect(dt2.toIso8601String(), '-0015-01-29');
    });
    test('To String', () {
      final dt = Date(2008, 12, 29);
      final dt2 = Date(-15, 01, 29);
      expect(dt.toString(), '2008-12-29');
      expect(dt2.toString(), '-0015-01-29');
    });
  });

  group('Comparison', () {
    test('equals', () {
      final dt = Date(2018, 02, 03);
      expect(Date(2018, 02, 03), dt);
    });

    test('CompareTo', () {
      final dt = Date(2008, 12, 29);
      final dt3 = Date.now();
      final dt2 = Date(-15, 01, 29);
      expect(dt3.compareTo(dt), 1);
      expect(dt2.compareTo(dt), -1);
      expect(dt.compareTo(dt), 0);
    });
    test('is Before', () {
      final dt = Date(2008, 12, 29);
      final dt2 = Date(-15, 01, 29);
      final dt3 = Date.now();

      expect(dt.isBefore(dt3), isTrue);
      expect(dt2.isBefore(dt), isTrue);
      expect(dt3.isBefore(dt2), isFalse);
    });
    test('is After', () {
      final dt = Date(2008, 12, 29);
      final dt2 = Date(-15, 01, 29);
      final dt3 = Date.now();

      expect(dt.isAfter(dt3), isFalse);
      expect(dt.isAfter(dt2), isTrue);
      expect(dt3.isAfter(dt2), isTrue);
    });

    test('toJson', () {
      final dt = Date(2018, 02, 03);
      expect(dt.toJson(), '2018-02-03');
    });
  });

  group('Formatting', () {
    test('Format to String', () {
      final dt = Date(2018, 02, 03);
      expect(dt.toYMMMMdString('en_US'), 'February 3, 2018');
      expect(dt.toYMMMMdString('it_IT'), '3 febbraio 2018');
      expect(dt.toYMMMMdString('te_IN'), '3 ఫిబ్రవరి, 2018');
    });

    test('Parse from String', () {
      final dt = Date(2018, 02, 03);
      expect(Date.parseYMMMMdString('3 febbraio 2018', 'it_IT'), dt);
      expect(Date.parseYMMMMdString('February 3, 2018', 'en_US'), dt);
      expect(Date.parseYMMMMdString('3 ఫిబ్రవరి, 2018', 'te_IN'), dt);
    });

    test('Format to String', () {
      final dt = Date(2018, 02, 03);
      expect(dt.toYMdString('en_US'), '2/3/2018');
      expect(dt.toYMdString('it_IT'), '3/2/2018');
      expect(dt.toYMdString('te_IN'), '3/2/2018');
    });

    test('Parse from String', () {
      final dt = Date(2018, 02, 03);
      expect(Date.parseYMdString('3/2/2018', 'it_IT'), dt);
      expect(Date.parseYMdString('2/3/2018', 'en_US'), dt);
      expect(Date.parseYMdString('3/2/2018', 'te_IN'), dt);
    });

    test('Format to String yMMdd', () {
      final dt = Date(2018, 02, 03);
      expect(dt.toYMMddString('en_US'), '02/03/2018');
      expect(dt.toYMMddString('it_IT'), '03/02/2018');
      expect(dt.toYMMddString('te_IN'), '03/02/2018');
    });

    test('Parse from String yMMdd', () {
      final dt = Date(2018, 02, 03);
      expect(Date.parseYMMddString('03/02/2018', 'it_IT'), dt);
      expect(Date.parseYMMddString('02/03/2018', 'en_US'), dt);
      expect(Date.parseYMMddString('03/02/2018', 'te_IN'), dt);
    });
  });
}
