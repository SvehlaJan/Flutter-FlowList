import 'package:flutter_flow_list/pages/chat/chat_view_model.dart';
import 'package:flutter_flow_list/repositories/api.dart';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:flutter_flow_list/util/Secrets.dart';
import 'package:flutter_flow_list/util/navigation/navigation_service.dart';
import 'package:flutter_flow_list/util/preferences.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingletonAsync<Preferences>(() async => Preferences.init());
  getIt.registerSingletonAsync<Secrets>(() async => SecretsLoader().load());
  getIt.registerLazySingleton(() => Api());
  getIt.registerLazySingleton(() => UserRepository.instance());
  getIt.registerLazySingleton(() => FlowRepository.instance());
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton(() => ChatViewModel());
//  getIt.registerSingletonAsync<FeatureService>(() async => FeatureService.init());
}
