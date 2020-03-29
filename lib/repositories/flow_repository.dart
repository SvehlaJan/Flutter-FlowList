import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_flow_list/locator.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/repositories/api.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:image/image.dart';

class FlowRepository {
  Api _api;

  FlowRepository.instance() {
    _api = getIt<Api>();
  }

  void setUserId(String userId) => _api.setUserId(userId);

  Stream<List<FlowRecord>> streamFlowRecords() {
    return _api.streamDataCollection().map((list) => list.documents.map((doc) => FlowRecord.fromDocumentSnapshot(doc)).toList());
  }

  Future<FlowRecord> getFlowRecord(DateTime dateTime) async {
    return FlowRecord.fromDocumentSnapshot(await _api.getDocumentById(FlowRecord.apiDateString(dateTime))) ?? FlowRecord.withDateTime(dateTime);
  }

  Future<void> deleteFlowRecord(DateTime dateTime) async {
    String dateStr = formatDate(dateTime, [yyyy, '-', mm, '-', dd]);
    return _api.removeDocument(dateStr);
  }

  Future<void> updateFlowRecord(FlowRecord flowRecord) async {
    return _api.updateDocument(flowRecord.toMap(), flowRecord.apiDateStr);
  }

  Future<dynamic> uploadImage(File sourceFile, DateTime dateTime) async {
    int fileSize = await sourceFile.length();
    print("Going to upload image file: ${sourceFile.path} with size: ${fileSize / 1024.0} KB");

    String userId = getIt<UserRepository>().currentUser.id;
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
    return copyResize(sourceImage, width: targetWidth, height: targetHeight);
  }
}
