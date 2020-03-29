import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';

class FlowRecord {
  static const String KEY_DATE = "date";
  static const String KEY_ENTRY_1 = "entry_1";
  static const String KEY_ENTRY_2 = "entry_2";
  static const String KEY_ENTRY_3 = "entry_3";
  static const String KEY_IMAGE_URL = "image_url";
  static const String KEY_GIF_URL = "gif_url";
  static const String KEY_DAY_SCORE = "day_score";
  static const String KEY_FAVORITE_ENTRY = "favorite_entry";
  static const String KEY_DATE_CREATED = "date_created";
  static const String KEY_DATE_MODIFIED = "date_modified";

  final DateTime dateTime;
  String firstEntry;
  String secondEntry;
  String thirdEntry;
  String imageUrl;
  String gifUrl;
  int favoriteEntry;
  int dayScore;
  DateTime dateModified;

  FlowRecord(this.dateTime, this.firstEntry, this.secondEntry, this.thirdEntry, this.imageUrl, this.gifUrl, this.favoriteEntry, this.dayScore, this.dateModified);

  String get apiDateStr => apiDateString(dateTime);

  bool get isSaved => dateModified != null;

  static FlowRecord withDateStr(String date, {String firstEntry, String secondEntry, String thirdEntry, String imageUrl, String gifUrl, int favoriteEntry, int dayScore, DateTime dateModified}) {
    return new FlowRecord(DateTime.parse(date), firstEntry, secondEntry, thirdEntry, imageUrl, gifUrl, favoriteEntry, dayScore, dateModified);
  }

  factory FlowRecord.withDateTime(DateTime dateTime,
      {String firstEntry, String secondEntry, String thirdEntry, String imageUrl, String gifUrl, int favoriteEntry, int dayScore, DateTime dateModified}) {
    return FlowRecord(dateTime, firstEntry, secondEntry, thirdEntry, imageUrl, gifUrl, favoriteEntry, dayScore, dateModified);
  }

  Map<String, dynamic> toMap() => {
        FlowRecord.KEY_ENTRY_1: firstEntry,
        FlowRecord.KEY_ENTRY_2: secondEntry,
        FlowRecord.KEY_ENTRY_3: thirdEntry,
        FlowRecord.KEY_IMAGE_URL: imageUrl,
        FlowRecord.KEY_GIF_URL: gifUrl,
        FlowRecord.KEY_FAVORITE_ENTRY: favoriteEntry,
        FlowRecord.KEY_DAY_SCORE: dayScore,
        FlowRecord.KEY_DATE_MODIFIED: DateTime.now().toIso8601String(),
      };

  factory FlowRecord.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data != null) {
      String dateStr = snapshot.documentID ?? "";
      DateTime dateTime = DateTime.parse(dateStr);
      String dateModifiedStr = snapshot.data[FlowRecord.KEY_DATE_MODIFIED] ?? "";
      DateTime dateTimeModified = DateTime.parse(dateModifiedStr);
      return FlowRecord(
        dateTime,
        snapshot.data[FlowRecord.KEY_ENTRY_1] ?? "",
        snapshot.data[FlowRecord.KEY_ENTRY_2] ?? "",
        snapshot.data[FlowRecord.KEY_ENTRY_3] ?? "",
        snapshot.data[FlowRecord.KEY_IMAGE_URL],
        snapshot.data[FlowRecord.KEY_GIF_URL],
        snapshot.data[FlowRecord.KEY_FAVORITE_ENTRY] ?? -1,
        snapshot.data[FlowRecord.KEY_DAY_SCORE],
        dateTimeModified,
      );
    } else {
      return null;
    }
  }

  static String apiDateString(DateTime dateTime) {
    return formatDate(dateTime, [yyyy, '-', mm, '-', dd]);
  }

  static String apiDateStringLong(DateTime dateTime) {
    return formatDate(dateTime, [yyyy, '-', mm, '-', dd, '_', HH, ':', nn, ':', ss]);
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
