import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'dart:convert' show json;

class Secrets {
  final String giphyApiKey;

  Secrets(this.giphyApiKey);

  factory Secrets.fromJson(Map<String, dynamic> jsonMap) {
    return Secrets(jsonMap["giphy_api_key"]);
  }
}

class SecretsLoader {
  final String secretsPath;

  SecretsLoader({this.secretsPath = "assets/secrets.json"});

  Future<Secrets> load() {
    return rootBundle.loadStructuredData<Secrets>(this.secretsPath, (jsonStr) async {
      return Secrets.fromJson(json.decode(jsonStr));
    });
  }
}
