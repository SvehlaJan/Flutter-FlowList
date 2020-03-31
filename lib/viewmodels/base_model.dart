import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_flow_list/locator.dart';
import 'package:flutter_flow_list/models/user_model.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';

abstract class BaseModel extends ChangeNotifier {

  @override
  void dispose() {
    super.dispose();
    showSnackBarController.close();
  }

  @protected
  StreamController<String> showSnackBarController = StreamController.broadcast();

  Stream<String> get showSnackBarStream => showSnackBarController.stream;

  @protected
  final UserRepository userRepository = getIt<UserRepository>();

  FlowUser get currentUser => userRepository.currentUser;

  bool get isUserLoggedIn => userRepository.isLoggedIn;

  bool _busy = false;

  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
