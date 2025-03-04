import 'package:flutter/material.dart';
import 'package:frontend/presentation/providers/cart_provider.dart';
import 'package:frontend/presentation/providers/user_provider.dart';
import 'package:frontend/presentation/providers/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend/presentation/pages/splash.dart';
import 'presentation/routes.dart';
import 'presentation/theme.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.initialize();

  runApp(MyApp(authProvider: authProvider));
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;

  const MyApp({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => authProvider),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CAS',
        theme: AppTheme.lightTheme(context),
        routes: routes,
        initialRoute: SplashScreen.routeName,
        // builder: (context, child) {
        //   return StreamBuilder<InternetStatus>(
        //     stream: InternetConnection().onStatusChange,
        //     builder: (context, snapshot) {
        //       if (snapshot.data == InternetStatus.disconnected) {
        //         return const NoInternetPage();
        //       } else {
        //         return child ?? Container();
        //       }
        //     },
        //   );
        // },
      ),
    );
  }
}

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/no-internet.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 40),
              Text(
                'No Internet Connection',
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF797979)),
              ),
              const SizedBox(height: 10),
              Text(
                  'berarti perangkat tidak terhubung ke internet. Periksa koneksi Wi-Fi atau data seluler Anda.',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF797979)),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
