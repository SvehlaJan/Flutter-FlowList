import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flow_list/locator.dart';
import 'package:flutter_flow_list/repositories/api.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockApi extends Mock implements Api {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

void main() {
  const String EMAIL = "joe@doe.com";
  const String PASSWORD = "Test123!";
  const String ACCESS_TOKEN = "access_token";
  const String ID_TOKEN = "id_token";
  const String USER_UID = "User123";
  const String USER_DISPLAY_NAME = "Joe Doe";
  const String USER_PHOTO_URL = "http://photo.jpg";

  // dependencies
  FirebaseAuth mockFirebaseAuth;

  StreamController<FirebaseUser> onAuthStateChangedStreamController = StreamController.broadcast();
  Stream<FirebaseUser> onAuthStateChangedStream = onAuthStateChangedStreamController.stream;

  group('FlowRepository Test | ', () {
    setUp(() {
      getIt.reset();
      setupLocator();
      getIt.allowReassignment = true;

      mockFirebaseAuth = MockFirebaseAuth();
      getIt.registerSingleton<FirebaseAuth>(mockFirebaseAuth);
      when(mockFirebaseAuth.onAuthStateChanged).thenAnswer((_) => onAuthStateChangedStream);
    });

    tearDown(() {
      onAuthStateChangedStreamController.close();
    });

    test('signOut signs out from Firebase and updates status', () async {
      // arrange

      // act
      await getIt<UserRepository>().signOut();

      // assert
      verify(mockFirebaseAuth.signOut());
      expect(getIt<UserRepository>().status, Status.Unauthenticated);
    });

    test('signInWithEmail sets status and signs in in Firebase', () async {
      // arrange

      // act
      await getIt<UserRepository>().signInWithEmail(EMAIL, PASSWORD);

      // assert
      expect(getIt<UserRepository>().status, Status.Authenticating);
      verify(mockFirebaseAuth.signInWithEmailAndPassword(email: EMAIL, password: PASSWORD));
    });

    test('signInWithGoogle sets status and signs in in Firebase', () async {
      // arrange
      GoogleSignIn mockGoogleSignIn = MockGoogleSignIn();
      GoogleSignInAuthentication googleAuth = MockGoogleSignInAuthentication();
      GoogleSignInAccount googleUser = MockGoogleSignInAccount();

      getIt.registerSingleton<GoogleSignIn>(mockGoogleSignIn);
      when(googleAuth.accessToken).thenReturn(ACCESS_TOKEN);
      when(googleAuth.idToken).thenReturn(ID_TOKEN);
      when(googleUser.authentication).thenAnswer((_) => Future.value(googleAuth));
      when(mockGoogleSignIn.signIn()).thenAnswer((_) => Future.value(googleUser));

      // act
      await getIt<UserRepository>().signInWithGoogle();

      // assert
      expect(getIt<UserRepository>().status, Status.Authenticating);
//      AuthCredential credential = GoogleAuthProvider.getCredential(accessToken: ACCESS_TOKEN, idToken: ID_TOKEN);
      // TODO - resolve how to match AuthCredential (most likely problem with named arguments)
      verify(mockFirebaseAuth.signInWithCredential(any));
    });

    test('signInAnonymously sets status and signs in in Firebase', () async {
      // arrange

      // act
      await getIt<UserRepository>().signInAnonymously();

      // assert
      expect(getIt<UserRepository>().status, Status.Authenticating);
      verify(mockFirebaseAuth.signInAnonymously());
    });

//    test('onAuthStateChangedStream updates the state with valid user correctly', () async {
//      // arrange
//      Api mockApi = MockApi();
//      FirebaseUser firebaseUser = MockFirebaseUser();
//      getIt.registerSingleton<Api>(mockApi);
//      FlowUser flowUser = FlowUser(USER_UID, USER_DISPLAY_NAME, USER_PHOTO_URL);
//
//      when(firebaseUser.uid).thenReturn(USER_UID);
//      when(firebaseUser.displayName).thenReturn(USER_DISPLAY_NAME);
//      when(firebaseUser.photoUrl).thenReturn(USER_PHOTO_URL);
//      userRepository = getIt<UserRepository>();
//
//      // act
//      onAuthStateChangedStreamController.add(firebaseUser);
//
//      // TODO - resolve how to wait for stream to emit value and onAuthStateChangedStream to listen
//
//      // assert
//      expect(userRepository.currentUser, flowUser);
//      expect(userRepository.status, Status.Authenticated);
//      verify(mockApi.setUserId(USER_UID));
//    });
  });
}
