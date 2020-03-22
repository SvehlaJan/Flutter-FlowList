import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_flow_list/locator.dart';
import 'package:flutter_flow_list/models/user_model.dart';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserRepository with ChangeNotifier {
  FirebaseAuth _firebaseAuth;
  FirebaseUser _firebaseUser;
  Status _status = Status.Uninitialized;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
//      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  StreamController<FlowUser> _onUserChangeController = StreamController.broadcast();

  Stream<FlowUser> get userStream => _onUserChangeController.stream;

  UserRepository.instance() : _firebaseAuth = FirebaseAuth.instance {
    _firebaseAuth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;

  FlowUser get currentUser => FlowUser.fromFirebase(_firebaseUser);

  bool get isLoggedIn => _status == Status.Authenticated;

  String getPhotoUrl() => _firebaseUser.photoUrl;

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInAnonymously() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      await _firebaseAuth.signInAnonymously();
      return true;
    } on PlatformException catch (e) {
      print(e);

      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _firebaseAuth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    _onUserChangeController.add(FlowUser.fromFirebase(firebaseUser));

    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _firebaseUser = firebaseUser;
      getIt<FlowRepository>().setUserId(firebaseUser.uid);
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
