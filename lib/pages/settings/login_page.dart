import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_flow_list/util/preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: <String>[
      'email',
//      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  static final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _authHint = '';

  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      GoogleSignInAccount googleUser = account;
      if (googleUser != null) {
        _logInFirebaseWithGoogle(googleUser);
      } else {
        setState(() {
//          requiresSignIn = true;
        });
      }
    });
  }

  Future<void> _logInFirebaseWithGoogle(GoogleSignInAccount googleUser) async {
    try {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final AuthResult authResult =
          await _firebaseAuth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      FirebaseUser newFirebaseUser = await _firebaseAuth.currentUser();
      assert(user.uid == newFirebaseUser.uid);

      _onSuccess(newFirebaseUser);
    } on PlatformException catch (e) {
      setState(() {
        _authHint = e.message;
      });
    }
  }

  Future<void> _logInFirebaseWithEmail(String email, String password) async {
    try {
      final AuthResult authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final FirebaseUser user = authResult.user;

      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      FirebaseUser newFirebaseUser = await _firebaseAuth.currentUser();
      assert(user.uid == newFirebaseUser.uid);

      _onSuccess(newFirebaseUser);
    } on PlatformException catch (e) {
      setState(() {
        _authHint = e.message;
      });
    }
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _logInFirebaseWithEmail(_email, _password);
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  void _onSuccess(FirebaseUser firebaseUser) async {
    Firestore.instance
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

    Navigator.of(context).pop(true);
  }

  void _onFailed() {
    print("Sign in failed!");
    Navigator.of(context).pop(false);
//    Navigator.of(context).pushAndRemoveUntil(
//        new MaterialPageRoute(
//            builder: (BuildContext context) => new LandingPage()),
//        (Route route) => route == null);
  }

  Future<void> signInWithGoogle() async {
    try {
      await _googleSignIn.signIn();
    } on PlatformException catch (e) {
      setState(() {
        _authHint = e.message;
      });
    }
  }

  Future<bool> _onWillPop() {
    Navigator.of(context).pop(false);
    return Future(() {
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: new AppBar(
            title: new Text("Login"),
          ),
          body: new Container(
              padding: const EdgeInsets.all(16.0),
              child: new Form(
                  key: formKey,
                  child: Center(
                    child:
//                      new TextFormField(
//                        keyboardType: TextInputType.emailAddress,
//                        key: new Key('email'),
//                        decoration: new InputDecoration(labelText: 'Email'),
//                        validator: (val) =>
//                            val.isEmpty ? 'Email can\'t be empty.' : null,
//                        onSaved: (val) => _email = val,
//                      ),
//                      new TextFormField(
//                        key: new Key('password'),
//                        decoration: new InputDecoration(labelText: 'Password'),
//                        obscureText: true,
//                        validator: (val) =>
//                            val.isEmpty ? 'Password can\'t be empty.' : null,
//                        onSaved: (val) => _password = val,
//                      ),
//                      new RaisedButton(
//                          key: new Key('login'),
//                          child: new Text('Login',
//                              style: new TextStyle(fontSize: 20.0)),
//                          onPressed: validateAndSubmit),
//                      new Container(
//                          height: 80.0,
//                          padding: const EdgeInsets.all(32.0),
//                          child: buildHintText()),
                        new RaisedButton(
                            key: new Key('google_login'),
                            color: Colors.redAccent,
                            child: new Text('Google Login',
                                style: Theme.of(context).textTheme.title),
                            onPressed: signInWithGoogle),
                  )))),
    );
  }

  Widget buildHintText() {
    return new Text(_authHint,
        key: new Key('hint'),
        style: new TextStyle(fontSize: 18.0, color: Colors.grey),
        textAlign: TextAlign.center);
  }
}
