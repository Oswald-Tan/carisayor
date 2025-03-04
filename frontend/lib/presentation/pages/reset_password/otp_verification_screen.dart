import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/login_register/login_screen.dart';
import 'package:frontend/presentation/pages/reset_password/reset_password_page.dart';
import 'package:frontend/data/services/otp_request_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  OtpVerificationScreenState createState() => OtpVerificationScreenState();
}

class OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());

  bool _isLoading = false;
  String? _expiryTime; // Untuk menyimpan waktu kadaluarsa OTP
  late Timer _timer;
  int _timeLeftInSeconds = 0; // Waktu sisa dalam detik

  // Fungsi untuk memverifikasi OTP
  void _verifyOtp() async {
    String otpCode =
        _otpControllers.map((controller) => controller.text).join();

    if (otpCode.length < 6) {
      Fluttertoast.showToast(msg: "Masukkan 6 digit kode OTP");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final otpService = OTPRequestService();
    final response = await otpService.verifyOtp(context, widget.email, otpCode);

    setState(() {
      _isLoading = false;
    });

    if (response != null) {
      Fluttertoast.showToast(msg: response.message);

      // Jika OTP valid, lanjutkan ke halaman reset password
      if (response.message == "OTP berhasil diverifikasi" && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ResetPasswordPage(email: widget.email)),
        );
      }
    } else {
      Fluttertoast.showToast(msg: "OTP tidak valid atau telah kedaluwarsa");
    }
  }

  // Fungsi untuk mendapatkan waktu kadaluarsa OTP
  void _getOtpExpiryTime() async {
    final otpService = OTPRequestService();
    final expiryTime =
        await otpService.getResetOtpExpiry(context, widget.email);

    if (expiryTime != null) {
      setState(() {
        _expiryTime = expiryTime;
        _timeLeftInSeconds =
            DateTime.parse(_expiryTime!).difference(DateTime.now()).inSeconds;
      });

      // Set timer untuk menghitung sisa waktu
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timeLeftInSeconds > 0) {
          setState(() {
            _timeLeftInSeconds--;
          });
        } else {
          _timer.cancel();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getOtpExpiryTime();
  }

  @override
  void dispose() {
    // Jangan lupa untuk dispose controller dan timer
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_timeLeftInSeconds / 60).floor();
    final seconds = _timeLeftInSeconds % 60;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Kode OTP',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    color: const Color(0xFF1F2131),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Masukkan kode OTP yang telah dikirim ke ${widget.email}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 16, color: Colors.grey[500]),
                ),
                const SizedBox(height: 20),
                if (_expiryTime != null)
                  Text(
                    "Waktu tersisa: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: Colors.grey[600]),
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: 53,
                      height: 53,
                      child: TextField(
                        controller: _otpControllers[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xFFEDF0F1), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xFFEDF0F1), width: 1),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF74B11A),
                  ),
                  child: _isLoading
                      ? Text(
                          'Loading...',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, color: Colors.white),
                        )
                      : Text(
                          'Verifikasi OTP',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
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
      ),
    );
  }
}
