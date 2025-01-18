import 'package:flutter/material.dart';
import 'package:frontend/screens/login_register/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5D9906),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: (MediaQuery.of(context).size.height - 150) / 2,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SizedBox(
                width: 150,
                height: 150,
                child: Image.asset("assets/images/casa_logo.png"),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: RichText(
                text: TextSpan(
                  text: 'Part of ',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Carisayor',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
