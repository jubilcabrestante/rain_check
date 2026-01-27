import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rain_check/app/app.dart';
import 'package:rain_check/features/calculate/flood_data_service.dart';
import 'package:rain_check/firebase_options.dart';

Future<void> firebaseMain(FirebaseOptions firebaseOptions) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: firebaseOptions);

  // ✅ Initialize GoogleSignIn with serverClientId
  await GoogleSignIn.instance.initialize(
    // Get this from your google-services.json file
    serverClientId: DefaultFirebaseOptions
        .currentPlatform
        .iosClientId, // This works for both platforms
  );
  await FloodDataService().initialize();
  // Run the app
  runApp(const MainApp());
}
