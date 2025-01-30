import 'package:flutter/material.dart';
import 'package:frontend/screens/login_register/login_screen.dart';
import 'package:frontend/screens/privacy_policy.dart';
import 'package:frontend/screens/terms_of_use.dart';
import 'package:frontend/widget/textfield/textfield_no_hp_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/widget/textfield/textfield_email_widget.dart';
import 'package:frontend/widget/textfield/textfield_pass_widget.dart';
import 'package:frontend/widget/textfield/textfield_username_widget.dart';
import 'package:frontend/widget/textfield/textfield_referral_by_widget.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';

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
  TextEditingController phoneNumber = TextEditingController();
  bool isAgreed = false; // State untuk checkbox

  @override
  void dispose() {
    referralBy.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    username.dispose();
    phoneNumber.dispose();
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign up',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              color: const Color(0xFF1F2131),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextfieldReferralCodeWidget(controller: referralBy),
                  const SizedBox(height: 10),
                  TextfieldUsernameWidget(controller: username),
                  const SizedBox(height: 10),
                  TextfieldEmailWidget(controller: email),
                  const SizedBox(height: 10),
                  TextfieldPhoneNumberWidget(controller: phoneNumber),
                  const SizedBox(height: 10),
                  TextfieldPasswordWidget(controller: password),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: 0.8,
                        child: Checkbox(
                          activeColor: const Color(0XFF74B11A),
                          value: isAgreed,
                          onChanged: (value) {
                            setState(() {
                              isAgreed = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PrivacyPolicyScreen()), // Privacy Policy
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'I agree to the ',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: GoogleFonts.poppins(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(
                                  text: ' and ',
                                  style: GoogleFonts.poppins(),
                                ),
                                TextSpan(
                                  text: 'Terms of Use',
                                  style: GoogleFonts.poppins(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const TermsOfUseScreen(), // Terms of Use
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!isAgreed) {
                          // Tampilkan pesan validasi jika tidak di-checklist
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "You must agree to the Privacy Policy and Terms of Use to register.",
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                          );
                          return;
                        }

                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);

                        final errorMessage = await authProvider.registerUser(
                          referralCode: referralBy.text,
                          username: username.text,
                          password: password.text,
                          email: email.text,
                          phoneNumber: phoneNumber.text,
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
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1F2131),
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "Login",
                            style: GoogleFonts.poppins(
                              color: const Color(0XFF74B11A),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
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
                          ),
                        ],
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
