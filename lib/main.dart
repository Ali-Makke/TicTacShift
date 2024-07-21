import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_shift/default_options.dart';
import 'package:tic_tac_shift/pages/wrapper.dart';
import 'package:tic_tac_shift/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// initializing the firebase app
  await Firebase.initializeApp(
      options: FirebaseOptions(
    messagingSenderId: const DefaultOptions().messagingSenderId,
    storageBucket: const DefaultOptions().storageBucket,
    projectId: const DefaultOptions().projectId,
    apiKey: const DefaultOptions().apiKey,
    appId: const DefaultOptions().appId,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthService().user,
      initialData: null,
      child: const MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
