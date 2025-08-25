import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



import 'package:yonetim_mibile_app/features/building/presentation/building_list_page.dart';
import 'package:yonetim_mibile_app/features/auth/presentation/login_page.dart';
import 'package:yonetim_mibile_app/features/auth/presentation/register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: '/Buildings/user-buildings',
        builder: (context, state) => const BuildingListPage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Yönetim Otomasyonu',
      routerConfig: _router,
    );
  }
}
