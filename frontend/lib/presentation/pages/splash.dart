import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/init_screen.dart';
import 'package:frontend/presentation/pages/login_register/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend/presentation/providers/auth_provider.dart';
import 'package:frontend/presentation/providers/user_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _getAppVersion();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward().whenComplete(() {
      _navigateToNextScreen();
    });
  }

  Future<void> _navigateToNextScreen() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Tunggu 2 detik sebelum navigasi (opsional)
    await Future.delayed(const Duration(seconds: 2));

    if (authProvider.isAuthenticated) {
      try {
        // Muat data pengguna terbaru
        await userProvider.getUserData(authProvider.token!);
        // Navigasi ke home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InitScreen()),
        );
      } catch (e) {
        // Jika token tidak valid, logout dan ke login
        await authProvider.logout();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  String? appVersion;

  Future<void> _getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appVersion = packageInfo.version;
      });
    } catch (e) {
      debugPrint("Error getting app version: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF74B11A),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     "assets/images/splash.png",
          //     fit: BoxFit.cover, // Agar gambar menutupi seluruh layar
          //   ),
          // ),
          Positioned(
            top: (MediaQuery.of(context).size.height - 135) / 2,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SizedBox(
                width: 135,
                child: Image.asset("assets/images/casa_logo.png"),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  appVersion != null ? "Versi $appVersion" : "",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
