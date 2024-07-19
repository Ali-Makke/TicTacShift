import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_shift/models/user_model.dart';
import 'package:tic_tac_shift/pages/local_game.dart';
import 'package:tic_tac_shift/pages/wrapper.dart';
import 'package:tic_tac_shift/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// initializing the firebase app
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: '',
    //  ==   current_key in google-services.json file
    appId: '',
    // ==  mobilesdk_app_id  in google-services.json file
    messagingSenderId: '',
    // ==   project_number in google-services.json file
    projectId: '',
    // ==   project_id   in google-services.json file
    storageBucket: '',
  )); // ==  storageBucket  in google-services.json file
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LocalGame());
    //   StreamProvider<UserModel?>.value(
    //   value: AuthService().user,
    //   initialData: null,
    //   child: const MaterialApp(
    //     home: Wrapper(),
    //   ),
    // );
  }
}
