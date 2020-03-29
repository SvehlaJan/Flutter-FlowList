import 'package:flutter_flow_list/locator.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_flow_list/util/navigation/navigation_service.dart';
import 'package:flutter_flow_list/viewmodels/base_model.dart';

class SettingsViewModel extends BaseModel {
  SettingsViewModel() {
    userRepository.statusStream.listen((event) {
      notifyListeners();
    });
  }

  void signOut() => userRepository.signOut();

  void onAccountClicked() => getIt<NavigationService>().navigateTo(Constants.settingsLoginRoute);
}
