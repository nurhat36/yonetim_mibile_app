import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yonetim_mibile_app/features/auth/presentation/login_page.dart';
import 'package:yonetim_mibile_app/features/auth/presentation/register_page.dart';
import 'package:yonetim_mibile_app/features/building/presentation/building_list_page.dart';

void main() {
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
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/Buildings/user-buildings': (_) => const BuildingListPage(),
      },
    );
  }
}
