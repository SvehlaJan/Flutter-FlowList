class FlowRecord {
  static const String KEY_DATE = "date";
  static const String KEY_ENTRY_1 = "entry_1";
  static const String KEY_ENTRY_2 = "entry_2";
  static const String KEY_ENTRY_3 = "entry_3";
  static const String KEY_SCORE = "score";
  static const String KEY_DATE_CREATED = "date_created";
  static const String KEY_DATE_MODIFIED = "date_modified";

  final String date;
  final String firstEntry;
  final String secondEntry;
  final String thirdEntry;

  const FlowRecord(this.date, this.firstEntry, this.secondEntry, this.thirdEntry);
}