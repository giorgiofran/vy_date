/// Copyright © 2016 Vidya sas. All rights reserved.
/// Created by Giorgio on 20/02/2017.

import 'dart:collection';
import 'package:intl/intl.dart' show DateFormat;

class Date implements Comparable<Date> {
  final DateTime _dateTime;
  static Map<String, DateFormat> YMMMdMap = SplayTreeMap<String, DateFormat>();
  static Map<String, DateFormat> YMdMap = SplayTreeMap<String, DateFormat>();

  Date(int year, [int month = 1, int day = 1])
      : _dateTime = DateTime.utc(year, month, day);

  factory Date.now() {
    final DateTime now = DateTime.now();
    return Date(now.year, now.month, now.day);
  }

  Date.fromDateTime(DateTime dt)
      : _dateTime = Date(dt.year, dt.month, dt.day)._dateTime;

  ///
  /// Constructs a new [Date] instance based on [formattedString].
  ///
  /// Throws a [FormatException] if the input cannot be parsed.
  ///
  /// The function parses a subset of ISO 8601
  /// which includes the subset accepted by RFC 3339.
  ///
  /// The accepted inputs are currently:
  ///
  /// * A date: A signed four-to-six digit year, two digit month and
  ///   two digit day, optionally separated by `-` characters.
  ///  Examples: "19700101", "-0004-12-24", "81030-04-01".
  ///
  /// This includes the output of both [toString] and [toIso8601String], which
  /// will be parsed back into a `DateTime` object with the same time as the
  /// original.
  ///
  /// The result is always in UTC.
  /// If a time zone offset other than UTC is specified,
  /// it is ignored.
  ///
  /// Examples of accepted strings:
  ///
  /// * `"2012-02-27 13:27:00"`
  /// * `"2012-02-27"`
  /// * `"20120227 13:27:00"`
  /// * `"20120227T132700"`
  /// * `"20120227"`
  /// * `"+20120227"`
  /// * `"2012-02-27T14Z"`
  /// * `"2012-02-27T14+00:00"`
  /// * `"-123450101 00:00:00 Z"`: in the year -12345.
  /// * `"2002-02-27T14:00:00-0500"`: Same as `"2002-02-27T19:00:00Z"`
  ///
  factory Date.parse(String formattedString) {
    ///
    /// date ::= yeardate time_opt timezone_opt
    /// yeardate ::= year colon_opt month colon_opt day
    /// year ::= sign_opt digit{4,6}
    /// colon_opt :: <empty> | ':'
    /// sign ::= '+' | '-'
    /// sign_opt ::=  <empty> | sign
    /// month ::= digit{2}
    /// day ::= digit{2}
    ///
    final RegExp re = RegExp(r'^([+-]?\d{4,6})-?(\d\d)-?(\d\d)'); // Day part.

    if (formattedString == null || formattedString == '') {
      return null;
    }
    final Match match = re.firstMatch(formattedString);
    if (match != null) {
      final int years = int.parse(match[1]);
      final int month = int.parse(match[2]);
      final int day = int.parse(match[3]);

      return Date(years, month, day);
    } else {
      throw FormatException('Invalid date format', formattedString);
    }
  }

  factory Date.parseYMMMMdString(String dateString, String locale) {
    DateFormat dt = YMMMdMap[locale];
    if (dt == null) {
      dt = DateFormat.yMMMMd(locale);
      YMMMdMap[locale] = dt;
    }
    final DateTime dateTime = dt.parse(dateString);
    return Date(dateTime.year, dateTime.month, dateTime.day);
  }

  factory Date.parseYMdString(String dateString, String locale) {
    DateFormat dt = YMdMap[locale];
    if (dt == null) {
      dt = DateFormat.yMd(locale);
      YMdMap[locale] = dt;
    }
    final DateTime dateTime = dt.parse(dateString);
    return Date(dateTime.year, dateTime.month, dateTime.day);
  }

  int get year => _dateTime.year;

  int get month => _dateTime.month;

  int get day => _dateTime.day;

  int get weekday => _dateTime.weekday;

  ///
  /// Returns true if [other] is a [Date] at the same day.
  ///
  @override
  bool operator ==(other) {
    if (other is! Date) {
      return false;
    }
    return _dateTime == other._dateTime;
  }

  @override
  int get hashCode => _dateTime.hashCode;

  @override
  int compareTo(Date other) => _dateTime.compareTo(other._dateTime);
  bool isAfter(Date other) => _dateTime.isAfter(other._dateTime);
  bool isBefore(Date other) => _dateTime.isBefore(other._dateTime);
  Date add(Duration duration) => Date.fromDateTime(_dateTime.add(duration));
  Date subtract(Duration duration) =>
      Date.fromDateTime(_dateTime.subtract(duration));
  Duration difference(Date other) => _dateTime.difference(other._dateTime);

  bool operator <(Date other) => compareTo(other) < 0;
  bool operator <=(Date other) => compareTo(other) <= 0;
  bool operator >=(Date other) => compareTo(other) >= 0;
  bool operator >(Date other) => compareTo(other) > 0;

  String toIso8601String() => _dateTime.toIso8601String().split('T')[0];
  @override
  String toString() => toIso8601String();

  Date duplicate() => Date(year, month, day);

  dynamic toJson([dynamic value]) {
    value ??= this;
    return value.toString();
  }

  DateTime toDateTime() => _dateTime;

  String toYMMMMdString(String locale) {
    DateFormat dt = YMMMdMap[locale];
    if (dt == null) {
      dt = DateFormat.yMMMMd(locale);
      YMMMdMap[locale] = dt;
    }
    return dt.format(_dateTime);
  }

  String toYMdString(String locale) {
    DateFormat dt = YMdMap[locale];
    if (dt == null) {
      dt = DateFormat.yMd(locale);
      YMdMap[locale] = dt;
    }
    return dt.format(_dateTime);
  }
}
