import 'dart:async';
import 'dart:io';

import 'package:flutter_flow_list/locator.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_flow_list/viewmodels/base_model.dart';
import 'package:image_picker/image_picker.dart';

class RecordsDetailViewModel extends BaseModel {
  FlowRepository _flowRepository = getIt<FlowRepository>();

  FlowRecord _record;

  FlowRecord get record => _record;

  bool _isEditMode = false;

  bool get isEditMode => _isEditMode;

  StreamController<FlowRecord> _resetRecordController = StreamController.broadcast();

  Stream<FlowRecord> get resetRecordStream => _resetRecordController.stream;

  @override
  void dispose() {
    super.dispose();

    _resetRecordController.close();
  }

  void fetchRecord(DateTime date) {
    if (!isUserLoggedIn) {
      notifyListeners();
      return;
    }

    setBusy(true);

    _flowRepository.getFlowRecord(date).then((record) {
      _record = record;
      _isEditMode = record.isSaved;
      _resetRecordController.add(record);

      notifyListeners();

      setBusy(false);
    });
  }

  void onDayScoreSelected(int score) {
    record.dayScore = score;
    notifyListeners();
  }

  void onFavoriteEntrySelected(int index) {
    record.favoriteEntry = index;
    notifyListeners();
  }

  Future<void> updateFlowRecord() async {
    return _flowRepository.updateFlowRecord(_record);
  }

  Future<void> deleteFlowRecord() async {
    return _flowRepository.deleteFlowRecord(_record.dateTime);
  }

  Future<void> getImage(ImageSource source) async {
    setBusy(true);

    File imageFile = await ImagePicker.pickImage(source: source, maxHeight: Constants.uploadImageMaxSize, maxWidth: Constants.uploadImageMaxSize);

    if (imageFile != null) {
      await uploadFile(imageFile);
    } else {
      setBusy(false);
    }
  }

  Future<void> uploadFile(File imageFile) async {
    _flowRepository.uploadImage(imageFile, DateTime.now()).then((downloadUrl) {
      _record.imageUrl = downloadUrl;
      setBusy(false);
    }, onError: (err) {
      showSnackBarController.add("This file is not an image");
      setBusy(false);
    });
  }
}
