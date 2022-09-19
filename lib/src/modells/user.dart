import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  String id;
  String? projectid;
  String role;

  CustomUser({required this.id, required this.projectid, required this.role});

  Map<String, dynamic> toJson() {
    return {"id": id, "projectid": projectid, "role": role};
  }

  static CustomUser fromJson(DocumentSnapshot<Object?> user) {
    return CustomUser(
      id: user["id"],
      projectid: user["projectid"] ?? "",
      role: user["role"],
    );
  }
}
