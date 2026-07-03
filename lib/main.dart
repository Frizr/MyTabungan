import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'package:tabungan_frontend/core/theme/app_theme.dart';
import 'package:tabungan_frontend/features/auth/views/auth_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TabunganKu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AuthChecker(),
    );
  }
}
