import 'package:flutter/material.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/splash.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'routes.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CAS',
        theme: AppTheme.lightTheme(context),
        routes: routes,
        // Menggunakan SplashScreen sebagai halaman pertama
        initialRoute: SplashScreen.routeName,
      ),
    );
  }
}
