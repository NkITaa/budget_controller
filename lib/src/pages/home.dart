import 'package:budget_controller/src/modells/user.dart';
import 'package:budget_controller/src/pages/admin/admin.dart';
import 'package:budget_controller/src/widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const.dart';
import '../controller/user_controller.dart';
import 'manager/manager.dart';
import 'owner/owner.dart';

// Gets User & handles him according to his role
class Home extends StatelessWidget {
  Home({super.key});

  // Gets Access to all methods of the UserController
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child:

            // Handles the User Future that is loaded in
            FutureBuilder<CustomUser>(
      future: userController.getUser(),
      builder: (
        BuildContext context,
        AsyncSnapshot<CustomUser> snapshot,
      ) {
        //shows ErrorText when Authentication Stream has an error
        if (snapshot.hasError) {
          return CustomBuilder.defaultFutureError(
              error: snapshot.error.toString());
        }

        //shows ProgressIndicator during loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: const CircularProgressIndicator());
        }

        CustomUser user = snapshot.data!;

        /// Returns the specific User UI
        ///
        /// * User == Manager -> Manager UI
        /// * User == Owner -> Owner UI
        /// * User == Admin -> Admin UI
        /// * User role unknown -> Error Text
        if (user.role == Const.userRoles[0]) {
          return Scaffold(
              appBar: CustomBuilder.customAppBar(context: context),
              drawer: CustomBuilder.customDrawer(
                  userGroup: Const.userRoles[0], context: context),
              body: Manager(
                user: user,
              ));
        }
        if (user.role == Const.userRoles[1]) {
          return Scaffold(
              appBar: CustomBuilder.customAppBar(context: context),
              drawer: CustomBuilder.customDrawer(
                  userGroup: Const.userRoles[1], context: context),
              body: Owner(
                user: user,
              ));
        }
        if (user.role == Const.userRoles[2]) {
          return Scaffold(
            appBar: CustomBuilder.customAppBar(context: context),
            drawer: CustomBuilder.customDrawer(
                userGroup: Const.userRoles[2], context: context),
            body: Admin(
              user: user,
            ),
          );
        } else {
          return const Center(
              child: Text(
            Const.roleUnknows,
          ));
        }
      },
    ));
  }
}
