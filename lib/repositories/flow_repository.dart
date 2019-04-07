import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_flow_list/util/preferences.dart';
import 'package:image/image.dart';

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
      FlowRecord.KEY_IMAGE_URL: flowRecord.imageUrl,
      FlowRecord.KEY_DAY_SCORE: flowRecord.dayScore,
      FlowRecord.KEY_FAVORITE_ENTRY: flowRecord.favoriteEntry,
      FlowRecord.KEY_DATE_MODIFIED: DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteFlowRecord(DateTime dateTime) async {
    String dateStr = FlowRecord.apiDateString(dateTime);
    DocumentReference dayReference = _getFirestoreReference().document(dateStr);
    return dayReference.delete();
  }

  Future<dynamic> uploadImage(File sourceFile, DateTime dateTime) async {
    int fileSize = await sourceFile.length();
    print("Going to upload image file: ${sourceFile.path} with size: ${fileSize / 1024.0} KB");

    String userId = Preferences.getString(Preferences.KEY_USER_UID) ?? "_";
    String fileName = userId + " " + FlowRecord.apiDateStringLong(dateTime);
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);

//    Image image = decodeImage(sourceFile.readAsBytesSync());
//    Image resizedImage = resizeImageFile(image, Constants.uploadImageMaxSize);
//    Uint8List imageData = Uint8List.fromList(encodeJpg(resizedImage, quality: 80));
//    print("Resized file with size: ${imageData.length}");
//    StorageUploadTask uploadTask = reference.putData(imageData);

    StorageUploadTask uploadTask = reference.putFile(sourceFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    return storageTaskSnapshot.ref.getDownloadURL();
  }

  Image resizeImageFile(Image sourceImage, double maxSize) {
    print("Resizing image with width: ${sourceImage.width}, height: ${sourceImage.height} to max size: $maxSize");
    int targetWidth = sourceImage.width > sourceImage.height ? maxSize : -1;
    int targetHeight = sourceImage.width > sourceImage.height ? -1 : maxSize;
    return copyResize(sourceImage, targetWidth, targetHeight);
  }
}
