import 'package:flutter/material.dart';
import 'package:frontend/screens/login_register/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/widget/textfield/textfield_email_widget.dart';
import 'package:frontend/widget/textfield/textfield_pass_widget.dart';
import 'package:frontend/widget/textfield/textfield_username_widget.dart';
import 'package:frontend/widget/textfield/textfield_referral_by_widget.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = "/register";

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController referralBy = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController username = TextEditingController();

  @override
  void dispose() {
    referralBy.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    username.dispose();
    super.dispose();
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
                      'Register',
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        color: const Color(0xFF1F2131),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextfieldReferralCodeWidget(controller: referralBy),
                  // Reuse TextfieldUsernameWidget for username input
                  TextfieldUsernameWidget(controller: username),
                  const SizedBox(height: 10),
                  // Reuse TextfieldEmailWidget for email input
                  TextfieldEmailWidget(controller: email),
                  // Reuse TextfieldPasswordWidget for password input
                  TextfieldPasswordWidget(controller: password),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);

                        final errorMessage = await authProvider.registerUser(
                          referralCode: referralBy.text,
                          username: username.text,
                          password: password.text,
                          email: email.text,
                          roleName: 'user',
                        );

                        if (errorMessage == null) {
                          // Tampilkan pesan sukses atau navigasi ke halaman login
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Registration Successful")),
                          );
                          Navigator.pop(context);
                        } else {
                          // Tampilkan pesan error dari API
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMessage)),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFF74B11A),
                      ),
                      child: Text(
                        'Register',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
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
                                      const LoginScreen(),
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
                              'Login',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
