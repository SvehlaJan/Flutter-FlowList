import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flow_list/locator.dart';
import 'package:flutter_flow_list/models/user_model.dart';
import 'package:flutter_flow_list/repositories/api.dart';
import 'package:flutter_flow_list/util/flow_logger.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserRepository {
  FirebaseAuth _firebaseAuth;
  FirebaseUser _firebaseUser;
  GoogleSignIn _googleSignIn;
  Status _status = Status.Uninitialized;

  StreamController<FlowUser> _onUserChangeController = StreamController.broadcast();

  Stream<FlowUser> get userStream => _onUserChangeController.stream;

  StreamController<Status> _onStatusChangeController = StreamController.broadcast();

  Stream<Status> get statusStream => _onStatusChangeController.stream;

  UserRepository.instance() {
    _googleSignIn = getIt<GoogleSignIn>();
    _firebaseAuth = getIt<FirebaseAuth>();
    _firebaseAuth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;

  FlowUser get currentUser => _firebaseUser != null ? FlowUser.fromFirebase(_firebaseUser) : null;

  bool get isLoggedIn => _status == Status.Authenticated;

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _setStatus(Status.Authenticating);

      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e, stackTrace) {
      FlowLogger.e(e, stackTrace);
      _setStatus(Status.Unauthenticated);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _setStatus(Status.Authenticating);

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await _firebaseAuth.signInWithCredential(credential);
      return true;
    } catch (e, stackTrace) {
      FlowLogger.e(e, stackTrace);
      _setStatus(Status.Unauthenticated);
      return false;
    }
  }

  Future<bool> signInAnonymously() async {
    try {
      _setStatus(Status.Authenticating);

      await _firebaseAuth.signInAnonymously();
      return true;
    } catch (e, stackTrace) {
      FlowLogger.e(e, stackTrace);
      _setStatus(Status.Unauthenticated);
      return false;
    }
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
    _setStatus(Status.Unauthenticated);
    return;
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    _firebaseUser = firebaseUser;

    if (firebaseUser == null) {
      _setStatus(Status.Unauthenticated);
    } else {
      getIt<Api>().setUserId(firebaseUser.uid);
      _setStatus(Status.Authenticated);
    }

    _onUserChangeController.add(currentUser);
  }

  void _setStatus(Status status) {
    _status = status;
    _onStatusChangeController.add(status);
  }
}
