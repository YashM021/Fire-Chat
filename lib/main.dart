
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fire_chat/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDmF-L8BD2LQtH2kFi8u6ziRaPl3hLxv_0',
      appId: '1:1070632976958:web:1863aa56a6a3099ffc476f',
      messagingSenderId: '1070632976958',
      projectId: 'fir-app-e5ad2',
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FireChat',
      home: WelcomeScreen(),
    );
  }
}
