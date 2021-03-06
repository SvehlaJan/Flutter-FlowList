import 'package:flutter/foundation.dart';
import 'package:flutter_flow_list/locator.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/pages/notes/detail/record_detail_page.dart';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_flow_list/util/navigation_service.dart';
import 'package:flutter_flow_list/viewmodels/base_model.dart';

class RecordsListViewModel extends BaseModel {
  FlowRepository _flowRepository = getIt<FlowRepository>();

  List<FlowRecord> _records;

  List<FlowRecord> get records => _records;

  RecordsListViewModel() {
    userRepository.userStream.listen((event) {
      listenToRecords();
    });
  }

  void listenToRecords() {
    if (!isUserLoggedIn) {
      notifyListeners();
      return;
    }

    setBusy(true);

    _flowRepository.streamFlowRecords().listen((recordsData) {
      List<FlowRecord> updatedRecords = recordsData;
      if (updatedRecords != null && updatedRecords.length > 0 && !listEquals(updatedRecords, _records)) {
        _records = updatedRecords;
        notifyListeners();
      }

      setBusy(false);
    });
  }

  void onRecordClicked(FlowRecord record) {
    getIt<NavigationService>().navigateTo(Constants.recordDetailRoute, arguments: RecordDetailPage.createArguments(dateStr: record.getApiDateString(), imageUrl: record.imageUrl));
  }

  void onChatClicked() {
    showSnackBarController.add("Not yet implemented");
  }

  void onLoginClicked() {
    getIt<NavigationService>().navigateTo(Constants.loginRoute);
  }
}
