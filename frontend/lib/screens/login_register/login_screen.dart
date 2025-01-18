import 'package:flutter/material.dart';
import 'package:frontend/screens/login_register/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/screens/reset_password/reset_password.dart';
import 'package:frontend/widget/textfield/textfield_email_widget.dart';
import 'package:frontend/widget/textfield/textfield_pass_widget.dart';
import 'package:frontend/screens/init_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/user_provider.dart'; // Pastikan UserProvider di-import

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen1State();
}

class _LoginScreen1State extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void login() async {
    setState(() {
      isLoading = true; // Set loading menjadi true ketika login dimulai
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      bool isLoggedIn = await authProvider.loginUser(
        email: email.text,
        password: password.text,
        userProvider: userProvider,
      );

      setState(() {
        isLoading = false;
      });

      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InitScreen()),
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString(), // Tampilkan pesan error langsung
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        print("Context not mounted, can't show SnackBar");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Text(
                      'Login',
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        color: const Color(0xFF1F2131),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextfieldEmailWidget(controller: email),
                  TextfieldPasswordWidget(controller: password),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResetPasswordScreen(),
                        ),
                      );
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Lupa Password?',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1F2131),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFF74B11A),
                      ),
                      child: isLoading
                          ? Text(
                              'Loading...',
                              style: GoogleFonts.poppins(color: Colors.white),
                            )
                          : Text(
                              'Login',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF1F2131),
                        fontSize: 14,
                      ),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const RegisterScreen(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(0.0, 1.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    var offsetAnimation =
                                        animation.drive(tween);

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Text(
                              'Register',
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF1F2131),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 47,
                    height: 47,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE9E8E8),
                    ),
                    child: const Center(
                      child: Image(
                        width: 25,
                        height: 25,
                        image: AssetImage('assets/images/google.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
