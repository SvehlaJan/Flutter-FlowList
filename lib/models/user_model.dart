import 'package:firebase_auth/firebase_auth.dart';

class FlowUser {
  final String id;
  final String name;
  final String photoUrl;

  FlowUser(this.id, this.name, this.photoUrl);

  factory FlowUser.fromJson(Map<String, dynamic> json) => FlowUser(json['id'], json['name'], json['photoUrl']);

  Map<dynamic, dynamic> toJson() => {'id': id, 'name': name, 'photoUrl': photoUrl};

  factory FlowUser.fromFirebase(FirebaseUser firebaseUser) {
    return FlowUser(firebaseUser.uid, firebaseUser.displayName, firebaseUser.photoUrl);
  }
}
