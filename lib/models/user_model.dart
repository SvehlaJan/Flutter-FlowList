import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FlowUser {
  String id;
  String name;

  FlowUser(this.id, this.name);

  factory FlowUser.fromJson(Map<String, dynamic> json) => FlowUser(json['id'], json['name']);

  Map<dynamic, dynamic> toJson() => {'id': id, 'name': name};

  factory FlowUser.fromFirestore(DocumentSnapshot documentSnapshot) {
    FlowUser user = FlowUser.fromJson(documentSnapshot.data);
    user.id = documentSnapshot.documentID;
    return user;
  }

  factory FlowUser.fromFirebase(FirebaseUser firebaseUser) {
    return FlowUser(firebaseUser.uid, firebaseUser.displayName);
  }
}
