import 'package:date_format/date_format.dart';

class FlowRecord {
  static const String KEY_DATE = "date";
  static const String KEY_ENTRY_1 = "entry_1";
  static const String KEY_ENTRY_2 = "entry_2";
  static const String KEY_ENTRY_3 = "entry_3";
  static const String KEY_SCORE = "score";
  static const String KEY_DATE_CREATED = "date_created";
  static const String KEY_DATE_MODIFIED = "date_modified";

  final DateTime dateTime;
  String firstEntry;
  String secondEntry;
  String thirdEntry;

  FlowRecord(this.dateTime, [this.firstEntry, this.secondEntry, this.thirdEntry]);

  static FlowRecord withDateStr(String date, String firstEntry, String secondEntry, String thirdEntry) {
    return new FlowRecord(DateTime.parse(date), firstEntry, secondEntry, thirdEntry);
  }

  static String apiDateString(DateTime dateTime) {
    return formatDate(dateTime, [yyyy, '-', mm, '-', dd]);
  }

  static String userDateString(DateTime dateTime) {
    return formatDate(dateTime, [dd, '.', mm, '.', yyyy]);
  }

  String getApiDateString() {
    return apiDateString(dateTime);
  }

  String getUserDateString() {
    return userDateString(dateTime);
  }
}