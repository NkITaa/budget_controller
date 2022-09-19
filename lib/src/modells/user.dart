import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  String id;
  String? projectId;
  String role;

  CustomUser({required this.id, required this.projectId, required this.role});

  Map<String, dynamic> toJson() {
    return {"id": id, "projectId": projectId, "role": role};
  }

  static CustomUser fromJson(DocumentSnapshot<Object?> user) {
    return CustomUser(
      id: user["id"],
      projectId: user["projectId"] ?? "",
      role: user["role"],
    );
  }
}
