import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  String id;
  String? projectsId;
  String role;

  CustomUser({required this.id, required this.projectsId, required this.role});

  Map<String, dynamic> toJson() {
    return {"id": id, "projectsId": projectsId, "role": role};
  }

  static CustomUser fromJson(DocumentSnapshot<Object?> user) {
    return CustomUser(
      id: user["id"],
      projectsId: user["projectsId"] ?? "",
      role: user["role"],
    );
  }
}
