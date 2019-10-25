import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

enum ColumnType { DAY, MONTH, YEAR }

class DatePickerAdapter extends PickerAdapter<DateTime> {
  final bool isNumberMonth;
  final List<String> months;
  final int yearBegin;
  final int yearMax, monthMax, dayMax;
  final String yearSuffix, monthSuffix, daySuffix;
  int _col = 0;
  DateTime value;

  static const List<String> MonthsList_EN = const [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  static const List<String> MonthsList_EN_L = const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  DatePickerAdapter(
      {Picker picker,
      this.isNumberMonth = false,
      this.months = MonthsList_EN,
      this.yearBegin = 1900,
      this.yearMax = 2100,
      this.monthMax = 12,
      this.dayMax = 31,
      this.value,
      this.yearSuffix = "",
      this.monthSuffix = "",
      this.daySuffix = ""}) {
    super.picker = picker;
  }

  static const List<int> leapYearMonths = const <int>[1, 3, 5, 7, 8, 10, 12];
  static const List<ColumnType> _columnType = const [
    ColumnType.DAY,
    ColumnType.MONTH,
    ColumnType.YEAR
  ];

  @override
  int getLength() {
    switch (_columnType[_col]) {
      case ColumnType.DAY:
        return _calcDayCount(value.year, value.month);
      case ColumnType.MONTH:
        return _calcMonthCount(value.year);
      case ColumnType.YEAR:
        return yearMax - yearBegin + 1;
    }
    return 0;
  }

  int _calcDayCount(int year, int month) {
    if (year == yearMax && month == monthMax) {
      return dayMax;
    } else if (leapYearMonths.contains(month)) {
      return 31;
    } else if (month == 2) {
      if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return 29;
      }
      return 28;
    }
    return 30;
  }

  int _calcMonthCount(int year) {
    return year == yearMax ? monthMax : 12;
  }

  @override
  int getMaxLevel() {
    return 3;
  }

  @override
  void setColumn(int index) {
    _col = index + 1;
    if (_col < 0) _col = 0;
  }

  @override
  void initSelects() {
    if (value == null) value = DateTime.now();
    int _maxLevel = getMaxLevel();
    if (picker.selecteds == null || picker.selecteds.length == 0) {
      if (picker.selecteds == null) picker.selecteds = new List<int>();
      for (int i = 0; i < _maxLevel; i++) picker.selecteds.add(0);
    }
  }

  @override
  Widget buildItem(BuildContext context, int index) {
    String _text = "";
    switch (_columnType[_col]) {
      case ColumnType.YEAR:
        _text = "${yearBegin + index}$yearSuffix";
        break;
      case ColumnType.MONTH:
        if (isNumberMonth) {
          _text = "${index + 1}$monthSuffix";
        } else {
          _text = "${months[index]}";
        }
        break;
      case ColumnType.DAY:
        _text = "${index + 1}$daySuffix";
        break;
    }

    return makeText(null, _text, false);
  }

  @override
  String getText() {
    return value.toString();
  }

  @override
  int getColumnFlex(int column) {
    if (_columnType[column] == ColumnType.YEAR) {
      return 3;
    }
    return 2;
  }

  @override
  void doShow() {
    for (int i = 0; i < _columnType.length; i++) {
      switch (_columnType[i]) {
        case ColumnType.DAY:
          picker.selecteds[i] = value.day - 1;
          break;
        case ColumnType.MONTH:
          picker.selecteds[i] = value.month - 1;
          break;
        case ColumnType.YEAR:
          picker.selecteds[i] = value.year - yearBegin;
          break;
      }
    }
  }

  @override
  void doSelect(int column, int index) {
    int year, month, day;
    year = value.year;
    month = value.month;
    day = value.day;

    switch (_columnType[column]) {
      case ColumnType.DAY:
        day = index + 1;
        break;
      case ColumnType.MONTH:
        month = index + 1;
        break;
      case ColumnType.YEAR:
        year = yearBegin + index;
        break;
    }

    bool dataChanged = false;
    int monthCount = _calcMonthCount(year);
    if (month > monthCount) {
      month = monthCount;
      dataChanged = true;
    }
    int dayCount = _calcDayCount(year, month);
    if (day > dayCount) {
      day = dayCount;
      dataChanged = true;
    }

    value = new DateTime(year, month, day);
    if (dataChanged) {
      notifyDataChanged();
    }
  }
}
