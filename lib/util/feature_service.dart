import 'package:firebase_remote_config/firebase_remote_config.dart';

class FeatureService {
  static const String FEATURE_FAVORITE_ENTRY = "feature_favorite_entry";
  static const bool FEATURE_FAVORITE_ENTRY_DEFAULT = false;
  static const defaults = <String, dynamic>{
    FEATURE_FAVORITE_ENTRY: FEATURE_FAVORITE_ENTRY_DEFAULT,
  };

  RemoteConfig remoteConfig;

  FeatureService._();

  static Future<FeatureService> init() async {
    FeatureService instance = FeatureService._();

    instance.remoteConfig = await RemoteConfig.instance;

    await instance.remoteConfig.setDefaults(defaults);
    await instance.remoteConfig.fetch(expiration: const Duration(hours: 12));
    await instance.remoteConfig.activateFetched();

    return instance;
  }

  bool getBool(String key) => remoteConfig.getBool(key);

  String getString(String key) => remoteConfig.getString(key);
}
