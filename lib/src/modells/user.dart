import 'package:cloud_firestore/cloud_firestore.dart';

// Definition of CustomUser Object
class CustomUser {
  String id;
  String? projectId;
  String role;

  CustomUser({required this.id, required this.projectId, required this.role});

  // Serializes Object to JSON
  Map<String, dynamic> toJson() {
    return {"id": id, "projectId": projectId, "role": role};
  }

  // Serializes Object from JSON
  static CustomUser fromJson(DocumentSnapshot<Object?> user) {
    return CustomUser(
      id: user["id"],
      projectId: user["projectId"],
      role: user["role"],
    );
  }
}
