import 'dart:convert';
import 'package:vy_date/vy_date.dart' show Date;

class DatePeriod implements Comparable<DatePeriod> {
  static const String fieldStartDate = 'startDate';
  static const String fieldDuration = 'duration';
  static const String fieldEndDate = 'endDate';
  static final Date startReference = Date(1970, 1, 1);
  static const Duration oneDay = Duration(days: 1);

  DatePeriod.byDuration(Date inclusiveStartDate, this.duration)
      : startDate = inclusiveStartDate {
    if (duration < oneDay) {
      throw ArgumentError('Start date must be lesser or equal to end date');
    }
  }

  factory DatePeriod(Date inclusiveStartDate, Date inclusiveEndDate) =>
      DatePeriod.byDuration(inclusiveStartDate,
          inclusiveEndDate.add(oneDay).difference(inclusiveStartDate));

  factory DatePeriod.parseYMMMMdString(String yMMMMdString, String locale) {
    final parts = yMMMMdString.split('\u2796');
    if (parts.length != 2) {
      throw ArgumentError(
          'Wrong input string. Cannot distinguish the two dates');
    }
    final start = Date.parseYMMMMdString(parts[0].trim(), locale);
    final end = Date.parseYMMMMdString(parts[1].trim(), locale);
    return DatePeriod(start, end);
  }

  factory DatePeriod.fromJson(Map<String, dynamic> map) => DatePeriod(
      Date.parse(map[fieldStartDate]), Date.parse(map[fieldEndDate]));

  factory DatePeriod.revive(String jsonString) =>
      DatePeriod.fromJson(json.decode(jsonString));

  final Date startDate;
  final Duration duration;

  Date get exclusiveEndDate => startDate.add(duration);

  Date get endDate => exclusiveEndDate.subtract(oneDay);

  int get inDays => duration.inDays;

  @override
  String toString() => 'From $startDate to $endDate ';

  @override
  bool operator ==(other) {
    return other is DatePeriod &&
        startDate == other.startDate &&
        duration == other.duration;
  }

  @override
  int get hashCode => Object.hash(startDate.hashCode, duration.hashCode);

  @override
  int compareTo(DatePeriod other) {
    final dateResult = startDate.compareTo(other.startDate);
    if (dateResult != 0) {
      return dateResult;
    }
    return duration.compareTo(other.duration);
  }

  bool operator <(DatePeriod other) => compareTo(other) < 0;

  bool operator <=(DatePeriod other) => compareTo(other) <= 0;

  bool operator >=(DatePeriod other) => compareTo(other) >= 0;

  bool operator >(DatePeriod other) => compareTo(other) > 0;

  Map<String, dynamic> toJson() =>
      <String, String>{fieldStartDate: '$startDate', fieldEndDate: '$endDate'};

  // ****************** Functional Methods ***************************

  String toYMMMMdString(String locale) => '${startDate.toYMMMMdString(locale)} '
      '\u2796 ${endDate.toYMMMMdString(locale)}';

  bool isInPeriod(Date date) => date >= startDate && date < exclusiveEndDate;

  String encode() => json.encode(this);

  DatePeriod duplicate() => DatePeriod.byDuration(startDate, duration);

  /// this method split the current period based on the month and day
  /// of the given Date. They are considered as end date (inclusive).
  ///
  /// Ex. a period 2015-07-09 => 2018-03-14, split by the date 2010-06-30
  /// returns the following periods:
  /// * 2015-07-09 => 2016-06-30
  /// * 2016-07-01 => 2017-06-30
  /// * 2017-07-01 => 2018-03-14
  List<DatePeriod> splitByEndDate(Date endDate) {
    final periods = <DatePeriod>[];
    var restPeriod = duplicate();
    var startPeriodDate = startDate.duplicate();
    var endPeriodDate = Date(startPeriodDate.year, endDate.month, endDate.day);

    if (startPeriodDate > endPeriodDate) {
      endPeriodDate = Date(endPeriodDate.year + 1, endDate.month, endDate.day);
    }
    do {
      if (restPeriod.endDate > endPeriodDate) {
        periods.add(DatePeriod(startPeriodDate, endPeriodDate));
        startPeriodDate = endPeriodDate.add(DatePeriod.oneDay);
        restPeriod = DatePeriod(startPeriodDate, restPeriod.endDate);
        endPeriodDate =
            Date(endPeriodDate.year + 1, endDate.month, endDate.day);
      } else {
        periods.add(DatePeriod(startPeriodDate, restPeriod.endDate));
        break;
      }
    } while (true);
    return periods;
  }
}
