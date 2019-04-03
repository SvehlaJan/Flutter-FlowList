import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_flow_list/util/preferences.dart';

class FlowRepository {
  static final FlowRepository _repo = new FlowRepository._internal();

  static FlowRepository get() {
    return _repo;
  }

  FlowRepository._internal() {
    // initialization code
    // todo - get temporary userId from firebase
//    init();
  }

  Future<void> init() async {
    await Preferences.load();
  }

  CollectionReference _getFirestoreReference() {
    String userId = Preferences.getString(Preferences.KEY_USER_UID);
    return Firestore.instance
        .collection(Constants.FIRESTORE_USERS)
        .document(userId)
        .collection(Constants.FIRESTORE_FLOW_NOTES);
  }

  Future<DocumentSnapshot> getFlowRecord([DateTime dateTime]) async {
    dateTime = dateTime ?? DateTime.now();
    String dateStr = FlowRecord.apiDateString(dateTime);
    DocumentReference dayReference = _getFirestoreReference().document(dateStr);
    return dayReference.get();
  }

  Stream<QuerySnapshot> getFlowRecords() {
    return _getFirestoreReference().snapshots();
  }

  Future<void> setFlowRecord(FlowRecord flowRecord) async {
    DocumentReference dayReference =
        _getFirestoreReference().document(flowRecord.getApiDateString());

    return dayReference.setData({
      FlowRecord.KEY_ENTRY_1: flowRecord.firstEntry,
      FlowRecord.KEY_ENTRY_2: flowRecord.secondEntry,
      FlowRecord.KEY_ENTRY_3: flowRecord.thirdEntry,
      FlowRecord.KEY_DATE_MODIFIED: DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteFlowRecord(DateTime dateTime) async {
    String dateStr = FlowRecord.apiDateString(dateTime);
    DocumentReference dayReference = _getFirestoreReference().document(dateStr);
    return dayReference.delete();
  }
}
