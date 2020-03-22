import 'package:flutter/widgets.dart';
import 'package:flutter_flow_list/locator.dart';
import 'package:flutter_flow_list/models/user_model.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';

abstract class BaseModel extends ChangeNotifier {

  BaseModel() {
    _userRepository.userStream.listen((event) {
      onUserChange();
    });
  }

  void onUserChange();

  final UserRepository _userRepository = getIt<UserRepository>();

  FlowUser get currentUser => _userRepository.currentUser;

  bool get isUserLoggedIn => _userRepository.isLoggedIn;

  bool _busy = false;

  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
