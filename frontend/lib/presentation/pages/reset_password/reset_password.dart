import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/login_register/login_screen.dart';
import 'package:frontend/presentation/pages/reset_password/otp_verification_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/data/services/otp_request_service.dart'; // Import service OTP
// import 'package:provider/provider.dart';
// import 'package:frontend/providers/user_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPasswordScreen extends StatefulWidget {
  static String routeName = "/reset_password";

  const ResetPasswordScreen({super.key});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false; // Tambahkan state loading

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _requestOtp() async {
    String email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      Fluttertoast.showToast(msg: "Masukkan email yang valid!");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final otpService = OTPRequestService();
    final response = await otpService.requestOtp(context, email);

    setState(() {
      _isLoading = false;
    });

    if (response != null && mounted) {
      Fluttertoast.showToast(msg: response.message);

      // Navigasi ke halaman OTP dengan mengirimkan email
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(email: email),
        ),
      );
    } else {
      Fluttertoast.showToast(msg: "Gagal mengirim OTP. Coba lagi.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      Text(
                        'Request OTP',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          color: const Color(0xFF1F2131),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Email yang diinput merupakan email aktif terdaftar!',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xFFEDF0F1), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xFFEDF0F1), width: 1),
                  ),
                  contentPadding:
                      const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                  labelText: 'Masukkan email',
                  labelStyle:
                      GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.alternate_email,
                      color: Colors.grey[400],
                      size: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _requestOtp, // Cegah spam klik
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF74B11A),
                ),
                child: Text(
                  _isLoading ? 'Loading...' : 'Request OTP',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const LoginScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    "Back to login?",
                    style: GoogleFonts.poppins(
                      color: Colors.grey[500],
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
