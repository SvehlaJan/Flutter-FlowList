import 'package:flutter_flow_list/pages/chat/chat_view_model.dart';
import 'package:flutter_flow_list/repositories/api.dart';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_flow_list/util/navigation/navigation_service.dart';
import 'package:flutter_flow_list/util/preferences.dart';
import 'package:flutter_flow_list/util/app_localization_service.dart';
import 'package:get_it/get_it.dart';
import 'package:giphy_client/giphy_client.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingletonAsync<Preferences>(() async => Preferences.init());
  getIt.registerLazySingleton(() => Api());
  getIt.registerLazySingleton(() => UserRepository.instance());
  getIt.registerLazySingleton(() => FlowRepository.instance());
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton(() => GiphyClient(apiKey: Constants.GIPHY_API_KEY));
  getIt.registerLazySingleton(() => ChatViewModel());
  getIt.registerLazySingleton(() => AppLocalizationsService());
//  getIt.registerSingletonAsync<FeatureService>(() async => FeatureService.init());
}
