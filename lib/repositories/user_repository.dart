import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_flow_list/util/preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  static final UserRepository _repo = new UserRepository._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
//      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  static UserRepository get() {
    return _repo;
  }

  UserRepository._internal() {
    // initialization code
  }

  Future<FirebaseUser> signIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _auth.signInWithCredential(credential);
    FirebaseUser firebaseUser = await _auth.currentUser();
    await _onSuccess(firebaseUser);

    return firebaseUser;
  }

  Future<bool> isSignedInAsync() {
    return _googleSignIn.isSignedIn();
  }
  
  bool isSignedIn() {
    return Preferences.getString(Preferences.KEY_USER_UID) != null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    
    await Preferences.load();
    Preferences.setString(Preferences.KEY_USER_UID, null);
    Preferences.setString(Preferences.KEY_USER_EMAIL, null);
    Preferences.setString(Preferences.KEY_USER_NICK_NAME, null);
    Preferences.setString(Preferences.KEY_USER_PHOTO_URL, null);
  }

  Future<String> getUserName() async {
    return (await _auth.currentUser()).displayName;
  }

  Future<void> _onSuccess(FirebaseUser firebaseUser) async {
    await Firestore.instance
        .collection(Constants.FIRESTORE_USERS)
        .document(firebaseUser.uid)
        .setData({
      Constants.FIRESTORE_ID: firebaseUser.uid,
      Constants.FIRESTORE_PROVIDER_ID: firebaseUser.providerId,
      Constants.FIRESTORE_NICKNAME: firebaseUser.displayName,
      Constants.FIRESTORE_EMAIL: firebaseUser.email,
      Constants.FIRESTORE_PHOTO_URL: firebaseUser.photoUrl,
    });

    await Preferences.load();
    Preferences.setString(Preferences.KEY_USER_UID, firebaseUser.uid);
    Preferences.setString(Preferences.KEY_USER_EMAIL, firebaseUser.email);
    Preferences.setString(
        Preferences.KEY_USER_NICK_NAME, firebaseUser.displayName);
    Preferences.setString(
        Preferences.KEY_USER_PHOTO_URL, firebaseUser.photoUrl);
  }
}
