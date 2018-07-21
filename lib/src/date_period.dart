/// Copyright © 2016 Vidya sas. All rights reserved.
/// Created by Giorgio on 28/04/2017.
import 'dart:convert';
import 'package:quiver/core.dart';
import 'package:vy_date/vy_date.dart' show Date;

class DatePeriod implements Comparable<DatePeriod> {
  static const String fieldStartDate = 'startDate';
  static const String fieldDuration = 'duration';
  static final Duration oneDay = new Duration(days: 1);
  static final Date startReference = new Date(1970, 1, 1);

  Date _startDate;
  Duration _duration;

  Date get startDate => _startDate;
  void set startDate(Date _value) {
    if (_value == null) {
      if (_startDate == null) {
        return;
      }
      if (isValid()) {
        _duration = exclusiveEndDate.difference(startReference);
      }
      _startDate = null;
      return;
    }
    if (isValid()) {
      if (endDate < _value) {
        throw new ArgumentError('Start Date must preceed End Date');
      }
      _duration = exclusiveEndDate.difference(_value);
    } else if (_duration != null) {
      Duration offsetDuration = _value.difference(startReference);
      _duration -= offsetDuration;
    }
    _startDate = _value;
  }

  @Deprecated('use startDate instead')
  Date get startingDate => _startDate;
  @Deprecated('use startDate instead')
  set startingDate(Date _value) => startDate = _value;

  Duration get duration => _duration;

  /// setting a duration without a start date defaults from 1970-1-1
  set duration(Duration _value) {
    if (_value == null) {
      _duration = null;
      return;
    }
    if (_value.isNegative || _value.inDays == 0) {
      throw new ArgumentError(
          'Negative or zero duration not allowed in DatePeriod creation');
    }
    _duration = new Duration(days: _value.inDays);
  }

  Date get exclusiveEndDate => _duration == null
      ? null
      : _startDate == null
          ? startReference.add(_duration)
          : _startDate.add(_duration);
  set exclusiveEndDate(Date _value) {
    if (_value == null) {
      _duration = null;
      return;
    }
    if (isValid()) {
      if (_value < _startDate) {
        throw new ArgumentError('Starting Date must preceed Ending Date');
      }
      _duration = _value.difference(_startDate);
    } else if (_startDate == null) {
      _duration = _value.difference(startReference);
/*
      if (_duration == null) {
        _startDate = _value.subtract(oneDay);
        _duration = _value.difference(_startDate);
      } else {
        _startDate = _value.subtract(_duration);
      }*/
    } else {
      if (_startDate.isAfter(_value)) {
        throw new ArgumentError('Ending date must follow starting one');
      }
      _duration = _value.difference(_startDate);
    }
  }

  @Deprecated('use endDate instead')
  Date get endingDate => endDate;
  @Deprecated('use endDate instead')
  set endingDate(Date _value) => endDate = _value;

  Date get endDate => exclusiveEndDate?.subtract(oneDay);
  set endDate(Date _value) => exclusiveEndDate = _value?.add(oneDay);

  int get inDays => _duration?.inDays;

  DatePeriod([this._startDate, Date _inclusiveEndDate]) {
    endDate = _inclusiveEndDate;
  }

  DatePeriod.byDuration(this._startDate, Duration duration) {
    this.duration = duration;
  }

  @override
  String toString() => 'From $_startDate to ${endDate} ';

  String toYMMMMdString(String locale) =>
      '${_startDate.toYMMMMdString(locale)} '
      '\u2796 ${endDate.toYMMMMdString(locale)}';

  static DatePeriod parseYMMMMdString(String yMMMMdString, String locale) {
    List<String> parts = yMMMMdString.split('\u2796');
    if (parts.length != 2)
      throw new ArgumentError(
          'Wrong input string. Cannot distinguish the two dates');
    Date start = Date.parseYMMMMdString(parts[0].trim(), locale);
    Date end = Date.parseYMMMMdString(parts[1].trim(), locale);
    return new DatePeriod(start, end);
  }

  Map<String, dynamic> toJson() {
    Map ret = <String, dynamic>{};
    ret[fieldStartDate] = _startDate?.toString();
    ret[fieldDuration] =
        _duration == null ? null : _duration.inMilliseconds.toString();
    return ret;
  }

  fromJson(Map<String, dynamic> map) {
    _startDate = Date.parse(map[fieldStartDate]);
    String durationString = map[fieldDuration];
    Duration duration;
    if (durationString == null)
      duration = null;
    else
      duration = new Duration(milliseconds: int.parse(durationString));
    _duration =
        duration; //new Duration(milliseconds: int.parse(map[fieldDuration]));
  }

  initFrom(DatePeriod period) {
    _startDate = period?._startDate;
    _duration = period?._duration;
  }

  static DatePeriod newFromMap(Map<String, dynamic> map) {
    String durationString = map[fieldDuration];
    Duration duration;
    if (durationString == null)
      duration = null;
    else
      duration = new Duration(milliseconds: int.parse(durationString));
    return new DatePeriod.byDuration(Date.parse(map[fieldStartDate]), duration);
    //map[fieldDuration] == null
    //    ? null
    //    : new Duration(milliseconds: int.parse(map[fieldDuration])));
  }

  DatePeriod duplicate() => new DatePeriod.byDuration(_startDate, _duration);

  String encode() => json.encode(this);
  static DatePeriod revive(String jsonString) {
    Map map = json.decode(jsonString);
    return DatePeriod.newFromMap(map);
  }

  // ******** functional methods ***********

  isValid() => _startDate != null && _duration != null;

  /// this method split the current period based on the month and day
  /// of the given Date. The are considered as end date (inclusive).
  /// Returns null if this period is not valid
  ///
  /// Ex. a period 2015-07-09 => 2018-03-14, split by the date 2010-06-30
  /// returns the following periods:
  /// * 2015-07-09 => 2016-06-30
  /// * 2016-07-01 => 2017-06-30
  /// * 2017-07-01 => 2018-03-14
  List<DatePeriod> splitByEndDate(Date endDate) {
    List<DatePeriod> periods = <DatePeriod>[];
    if (!isValid()) {
      return null;
    }
    DatePeriod restPeriod = this.duplicate();
    int referenceYear = startDate.year;
    Date referenceDate = startDate.duplicate();
    Date compareDate = new Date(referenceYear, endDate.month, endDate.day);
    if (startDate > compareDate) {
      referenceYear++;
      compareDate = new Date(referenceYear, endDate.month, endDate.day);
    }
    do {
      if (restPeriod.endDate > compareDate) {
        periods.add(new DatePeriod(referenceDate, compareDate));
        referenceDate = compareDate.add(oneDay);
        restPeriod.startDate = referenceDate;
        referenceYear++;
        compareDate = new Date(referenceYear, endDate.month, endDate.day);
      } else {
        periods.add(new DatePeriod(referenceDate, restPeriod.endDate));
        break;
      }
    } while (restPeriod != null);
    return periods;
  }

  /// Last Date included
  @Deprecated('Use endDate instead')
  Date getEndDate() {
    if (startDate == null || _duration == null) return null;
    Date ret = startDate.add(_duration);
    return ret;
  }

  /// First date excluded
  @Deprecated('Use exclusiveEndDate')
  Date getFirstExcludedDay() {
    Date ret = getEndDate();
    if (ret == null) return null;
    ret = ret.add(new Duration(days: 1));
    return new Date(ret.year, ret.month, ret.day);
  }

  @Deprecated('use inDays instead')
  int getDays() {
    //Used to avoid problems with dayLight-savings switch
    int days = (_duration.inHours + 1) ~/ 24;
    return days;
  }

  bool isInPeriod(Date date) {
    if (exclusiveEndDate == null) return false;
    return date >= _startDate && date < exclusiveEndDate;
  }

  @override
  bool operator ==(other) {
    return other is DatePeriod &&
        _startDate == other._startDate &&
        _duration == other._duration;
  }

  @override
  int get hashCode => hash2(_startDate.hashCode, _duration.hashCode);

  @override
  int compareTo(DatePeriod other) {
    if (!isValid()) {
      throw new StateError('Invalid period cannot be compared');
    }
    if (!other.isValid()) {
      throw new ArgumentError(
          'The comparison period is not valid and cannot be compared');
    }
    int dateResult = _startDate.compareTo(other._startDate);
    if (dateResult != 0) return dateResult;
    return _duration.compareTo(other._duration);
  }

  bool operator <(DatePeriod other) => compareTo(other) < 0;
  bool operator <=(DatePeriod other) => compareTo(other) <= 0;
  bool operator >=(DatePeriod other) => compareTo(other) >= 0;
  bool operator >(DatePeriod other) => compareTo(other) > 0;
}
