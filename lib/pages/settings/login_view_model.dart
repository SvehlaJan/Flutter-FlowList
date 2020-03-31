import 'package:flutter_flow_list/locator.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:flutter_flow_list/viewmodels/base_model.dart';

class LoginViewModel extends BaseModel {
  LoginViewModel() {
    userRepository.statusStream.listen((event) {
      notifyListeners();
    });
  }

  Status get currentStatus => userRepository.status;

  Future<bool> signInWithEmail(String email, String password) async => userRepository.signInWithEmail(email, password);

  Future<bool> signInWithGoogle() async => userRepository.signInWithGoogle();

  Future<bool> signInAnonymously() async => userRepository.signInAnonymously();

  void signOut() => userRepository.signOut();
}
