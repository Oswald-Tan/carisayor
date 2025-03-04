import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/loading_page.dart';
import 'package:frontend/presentation/pages/login_register/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/presentation/pages/reset_password/reset_password.dart';
import 'package:frontend/presentation/widget/textfield/textfield_email_widget.dart';
import 'package:frontend/presentation/widget/textfield/textfield_pass_widget.dart';
import 'package:frontend/presentation/pages/init_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend/presentation/providers/auth_provider.dart';
import 'package:frontend/presentation/providers/user_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen1State();
}

class _LoginScreen1State extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Tambahkan ini
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void showErrorMessage(BuildContext context, String error) {
    Fluttertoast.showToast(
      msg: error,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  void login() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Semua input harus diisi',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return;
    }

    setState(() {
      isLoading = true; // Set loading menjadi true ketika login dimulai
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      // Tampilkan halaman loading sebelum proses login dimulai
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoadingPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );

      // Proses login
      bool isLoggedIn = await authProvider.loginUser(
        email: email.text,
        password: password.text,
        userProvider: userProvider,
      );

      // Jika login berhasil
      if (isLoggedIn && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InitScreen()),
        );
      }
    } catch (error) {
      // Jika terjadi error
      setState(() {
        isLoading = false;
      });

      // Tutup halaman loading dan kembali ke login
      if (mounted) {
        Navigator.pop(context); // Tutup LoadingPage

        // Jika error adalah timeout, tampilkan modal bottom sheet
        if (error.toString().contains('Connection timeout')) {
          _showTimeoutBottomSheet(context);
        } else {
          // Jika error lainnya, tampilkan pesan error dengan Fluttertoast
          showErrorMessage(context, error.toString());
        }
      } else {
        debugPrint("Context not mounted, can't show SnackBar");
      }
    }
  }

  void _showTimeoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/timeout.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              Text(
                'Connection Timeout',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Koneksi ke server memakan waktu terlalu lama. '
                'Silakan periksa koneksi internet Anda dan coba lagi.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup modal bottom sheet
                    login(); // Coba login lagi
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFF74B11A),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Try Again',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Log in',
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
                  TextfieldEmailWidget(controller: email),
                  const SizedBox(height: 10),
                  TextfieldPasswordWidget(controller: password),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                        text: 'Lupa Password?',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[500],
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ResetPasswordScreen(),
                              ),
                            );
                          },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      style: ElevatedButton.styleFrom(),
                      child: isLoading
                          ? Text(
                              'Loading...',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            )
                          : Text(
                              'Login',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: GoogleFonts.poppins(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: "Sign up",
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  // const SizedBox(height: 20),
                  // Container(
                  //   margin: const EdgeInsets.only(top: 10),
                  //   width: 47,
                  //   height: 47,
                  //   decoration: const BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     color: Color(0xFFE9E8E8),
                  //   ),
                  //   child: const Center(
                  //     child: Image(
                  //       width: 25,
                  //       height: 25,
                  //       image: AssetImage('assets/images/google.png'),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
