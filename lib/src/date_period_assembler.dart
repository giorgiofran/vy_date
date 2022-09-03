import 'package:quiver/core.dart' show hash2;
import 'package:vy_date/src/date.dart';
import 'package:vy_date/src/date_period.dart';

// *******************************************************
// ******************** Assembler ************************
// *******************************************************
class DatePeriodAssembler {
  Date? _startDate;
  Duration? _duration;

  Date? get startDate => _startDate;

  set startDate(Date? value) {
    if (value == null) {
      if (_startDate == null) {
        return;
      }
      if (isValid()) {
        _duration = exclusiveEndDate?.difference(DatePeriod.startReference);
      }
      _startDate = null;
      return;
    }
    if (isValid()) {
      if (endDate! < value) {
        throw ArgumentError('Start Date must preceed End Date');
      }
      _duration = exclusiveEndDate?.difference(value);
    } else if (_duration != null) {
      Duration offsetDuration;
      offsetDuration = value.difference(DatePeriod.startReference);
      _duration = _duration! - offsetDuration;
    }
    _startDate = value;
  }

  Duration? get duration => _duration;

  /// setting a duration without a start date defaults from 1970-1-1
  set duration(Duration? value) {
    if (value == null) {
      _duration = null;
      return;
    }
    if (value.isNegative || value.inDays == 0) {
      throw ArgumentError(
          'Negative or zero duration not allowed in DatePeriod creation');
    }
    _duration = Duration(days: value.inDays);
  }

  Date? get exclusiveEndDate => _duration == null
      ? null
      : _startDate == null
          ? DatePeriod.startReference.add(_duration!)
          : _startDate!.add(_duration!);

  set exclusiveEndDate(Date? value) {
    if (value == null) {
      _duration = null;
      return;
    }
    if (isValid()) {
      if (value < _startDate!) {
        throw ArgumentError('Starting Date must preceed Ending Date');
      }
      _duration = value.difference(_startDate!);
    } else if (_startDate == null) {
      _duration = value.difference(DatePeriod.startReference);
    } else {
      if (_startDate!.isAfter(value)) {
        throw ArgumentError('Ending date must follow starting one');
      }
      _duration = value.difference(_startDate!);
    }
  }

  Date? get endDate => exclusiveEndDate?.subtract(DatePeriod.oneDay);
  set endDate(Date? value) =>
      exclusiveEndDate = value?.add(DatePeriod.oneDay);

  int? get inDays => _duration?.inDays;

  DatePeriodAssembler([this._startDate, Date? inclusiveEndDate]) {
    endDate = inclusiveEndDate;
  }

  DatePeriodAssembler.byDuration(Date startDate, Duration duration) {
    _startDate = startDate;
    this.duration = duration;
  }

  DatePeriodAssembler.byPeriod(DatePeriod period)
      : _startDate = period.startDate,
        _duration = period.duration;

  @override
  String toString() => 'From $_startDate to $endDate ';

  String toYMMMMdString(String locale) =>
      '${_startDate?.toYMMMMdString(locale) ?? '\u00a0'} '
      '\u2796 ${endDate?.toYMMMMdString(locale) ?? '\u00a0'}';

  static DatePeriodAssembler parseYMMMMdString(
      String yMMMMdString, String locale) {
    final parts = yMMMMdString.split('\u2796');
    if (parts.length != 2) {
      throw ArgumentError(
          'Wrong input string. Cannot distinguish the two dates');
    }
    final start = Date.parseYMMMMdString(parts[0].trim(), locale);
    final end = Date.parseYMMMMdString(parts[1].trim(), locale);
    return DatePeriodAssembler(start, end);
  }

  void initFrom(DatePeriod period) {
    _startDate = period.startDate;
    _duration = period.duration;
  }

  DatePeriod generate() => isValid()
      ? DatePeriod.byDuration(_startDate!, _duration!)
      : throw ArgumentError('Invalid DatePeriod');

  static DatePeriodAssembler newFromMap(Map<String, dynamic> map) {
    return DatePeriodAssembler(Date.parse(map[DatePeriod.fieldStartDate]),
        Date.parse(map[DatePeriod.fieldEndDate]));
  }

  DatePeriodAssembler duplicate() => DatePeriodAssembler(_startDate, endDate);

  // ******** functional methods ***********

  bool isValid() => _startDate != null && _duration != null;

  @override
  bool operator ==(other) {
    return other is DatePeriodAssembler &&
        _startDate == other._startDate &&
        _duration == other._duration;
  }

  @override
  int get hashCode => hash2(_startDate.hashCode, _duration.hashCode);
}
