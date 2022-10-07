import 'package:budget_controller/firebase_options.dart';
import 'package:budget_controller/src/controller/project_controller.dart';
import 'package:budget_controller/src/controller/user_controller.dart';
import 'package:budget_controller/src/pages/home.dart';
import 'package:budget_controller/src/pages/login/login.dart';
import 'package:budget_controller/src/widget_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Enables popping of CircularProgressIndicator
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Enables messaging through Flutters SnackBar
final GlobalKey<ScaffoldMessengerState> messengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Initializes:
///
/// * Firebase
/// * UserController
/// * ProjectController
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(UserController());
  Get.put(ProjectController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        scaffoldMessengerKey: messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,

        /// Sets Applications:
        ///
        /// * TextTheme
        /// * ScaffoldTheme
        theme: ThemeData(
          textTheme: GoogleFonts.dmSansTextTheme(
            Theme.of(context).textTheme.apply(bodyColor: Colors.white),
          ),
          scaffoldBackgroundColor: const Color(0xff7434E6),
        ),

        // Listens to AuthenticatedStream:
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // Shows ProgressIndicator during loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Shows ErrorText when AuthenticatedStream has an error
            if (snapshot.hasError) {
              return CustomBuilder.defaultFutureError(
                  error: snapshot.error.toString());
            }

            /// Alters Screen depending if user is authenticated
            ///
            /// * User authenticated: HomeScreen
            /// * User not authenticated: LoginScreen
            if (snapshot.hasData) {
              return Home();
            } else {
              return const Login();
            }
          },
        ));
  }
}
