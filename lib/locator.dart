import 'package:flutter_flow_list/repositories/api.dart';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => Api());
  getIt.registerLazySingleton(() => UserRepository.instance());
  getIt.registerLazySingleton(() => FlowRepository.instance());
}
