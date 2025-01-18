import 'package:flutter/widgets.dart';
// import 'package:frontend/screens/complete/complete_screen.dart';

import 'package:frontend/screens/login_register/login_screen.dart';
import 'package:frontend/screens/login_register/register_screen.dart';
// import 'package:frontend/screens/top_up/topup_screen.dart';
import 'screens/splash.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'screens/reset_password/reset_password.dart';
import 'screens/init_screen.dart';

final Map<String, WidgetBuilder> routes = {
  InitScreen.routeName: (context) => const InitScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  // CompleteScreen.routeName: (context) => const CompleteScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  // TopUpPage.routeName: (context) => const TopUpPage(),
  ResetPasswordScreen.routeName: (context) => ResetPasswordScreen(),
};
