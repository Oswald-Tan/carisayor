import 'package:flutter/widgets.dart';
import 'package:frontend/presentation/pages/login_register/login_screen.dart';
import 'package:frontend/presentation/pages/login_register/register_screen.dart';
import 'package:frontend/presentation/pages/top_up/topup_screen.dart';
import 'pages/splash.dart';
import 'package:frontend/presentation/pages/home/home_screen.dart';
import 'pages/reset_password/reset_password.dart';
import 'pages/init_screen.dart';

final Map<String, WidgetBuilder> routes = {
  InitScreen.routeName: (context) => const InitScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  ResetPasswordScreen.routeName: (context) => const ResetPasswordScreen(),
  TopUpPage.routeName: (context) => const TopUpPage(),
};
