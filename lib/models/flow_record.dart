import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';

class FlowRecord {
  static const String KEY_DATE = "date";
  static const String KEY_ENTRY_1 = "entry_1";
  static const String KEY_ENTRY_2 = "entry_2";
  static const String KEY_ENTRY_3 = "entry_3";
  static const String KEY_IMAGE_URL = "image_url";
  static const String KEY_DAY_SCORE = "day_score";
  static const String KEY_FAVORITE_ENTRY = "favorite_entry";
  static const String KEY_DATE_CREATED = "date_created";
  static const String KEY_DATE_MODIFIED = "date_modified";

  final DateTime dateTime;
  String firstEntry;
  String secondEntry;
  String thirdEntry;
  String imageUrl;
  int favoriteEntry;
  int dayScore;

  FlowRecord(this.dateTime,
      {this.firstEntry,
      this.secondEntry,
      this.thirdEntry,
      this.imageUrl,
      this.favoriteEntry,
      this.dayScore});

  static FlowRecord withDateStr(String date,
      {String firstEntry,
      String secondEntry,
      String thirdEntry,
      String imageUrl,
      int favoriteEntry,
      int dayScore}) {
    return new FlowRecord(DateTime.parse(date),
        firstEntry: firstEntry,
        secondEntry: secondEntry,
        thirdEntry: thirdEntry,
        imageUrl: imageUrl,
        favoriteEntry: favoriteEntry,
        dayScore: dayScore);
  }

  static FlowRecord fromSnapShot(DocumentSnapshot document) {
    return FlowRecord(DateTime.parse(document.documentID),
        firstEntry: document[FlowRecord.KEY_ENTRY_1],
        secondEntry: document[FlowRecord.KEY_ENTRY_2],
        thirdEntry: document[FlowRecord.KEY_ENTRY_3],
        imageUrl: document[FlowRecord.KEY_IMAGE_URL],
        favoriteEntry: document[FlowRecord.KEY_FAVORITE_ENTRY] ?? -1,
        dayScore: document[FlowRecord.KEY_DAY_SCORE]);
  }

  static String apiDateString(DateTime dateTime) {
    return formatDate(dateTime, [yyyy, '-', mm, '-', dd]);
  }

  static String apiDateStringLong(DateTime dateTime) {
    return formatDate(
        dateTime, [yyyy, '-', mm, '-', dd, '_', HH, ':', nn, ':', ss]);
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
