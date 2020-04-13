import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flow_list/pages/chat/chat_view_model.dart';
import 'package:flutter_flow_list/repositories/api.dart';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:flutter_flow_list/util/feature_service.dart';
import 'package:flutter_flow_list/util/secrets.dart';
import 'package:flutter_flow_list/util/navigation_service.dart';
import 'package:flutter_flow_list/util/preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingletonAsync<Preferences>(() async => Preferences.init());
  getIt.registerLazySingletonAsync<Secrets>(() async => SecretsLoader().load());
  getIt.registerLazySingletonAsync<FeatureService>(() async => FeatureService.init());

  getIt.registerLazySingleton<Api>(() => Api());
  getIt.registerLazySingleton<UserRepository>(() => UserRepository.instance());
  getIt.registerLazySingleton<FlowRepository>(() => FlowRepository.instance());
  getIt.registerLazySingleton<NavigationService>(() => NavigationService());
  getIt.registerLazySingleton<ChatViewModel>(() => ChatViewModel());
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn(scopes: <String>['email']));
}
