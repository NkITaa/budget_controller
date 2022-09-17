import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  String id;
  List<String>? projectsId;
  String role;

  CustomUser({required this.id, required this.projectsId, required this.role});

  Map<String, dynamic> toJson() {
    return {"id": id, "projectsId": projectsId, "role": role};
  }

  static CustomUser fromJson(DocumentSnapshot<Object?> user) {
    List<dynamic> projectsID = user["projectsId"] ?? [];
    return CustomUser(
      id: user["id"],
      projectsId: projectsID.cast<String>(),
      role: user["role"],
    );
  }
}
