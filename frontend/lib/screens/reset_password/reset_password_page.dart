import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/screens/login_register/login_screen.dart';
import 'package:frontend/services/otp_request_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool obscureTextNew = true; // Untuk password baru
  bool obscureTextConfirm = true; // Untuk konfirmasi password

  // Menyimpan status validasi kriteria password
  bool isLengthValid = false;
  bool isNumberValid = false;
  bool isUppercaseValid = false;
  bool isLowercaseValid = false;
  bool isSpecialCharacterValid = false;

  // Fungsi untuk mereset password
  void _resetPassword() async {
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Validasi input
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter new password and confirm it");
      return;
    }

    if (newPassword != confirmPassword) {
      Fluttertoast.showToast(msg: "Passwords do not match");
      return;
    }

    // Check if password meets the required conditions
    if (!isValidPassword(newPassword)) {
      Fluttertoast.showToast(msg: "Password does not meet the requirements");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final otpRequestService = OTPRequestService();
    final response = await otpRequestService.resetPassword(
      context,
      widget.email,
      newPassword,
      confirmPassword,
    );

    setState(() {
      _isLoading = false;
    });

    if (response != null) {
      String message = response.message;
      Fluttertoast.showToast(msg: message);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else {
      Fluttertoast.showToast(msg: "An error occurred. Please try again.");
    }
  }

  bool isValidPassword(String password) {
    // Check if the password has at least 8 characters, contains a number,
    // contains a lowercase letter, and contains an uppercase letter
    RegExp passwordRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  // Fungsi untuk memvalidasi kriteria password
  void _checkPasswordCriteria(String password) {
    setState(() {
      // Validasi setiap kriteria password
      isLengthValid = password.length >= 8;
      isNumberValid = RegExp(r'\d').hasMatch(password);
      isUppercaseValid = RegExp(r'[A-Z]').hasMatch(password);
      isLowercaseValid = RegExp(r'[a-z]').hasMatch(password);
      isSpecialCharacterValid =
          RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    });
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Reset Password',
              style: GoogleFonts.poppins(
                fontSize: 28,
                color: const Color(0xFF1F2131),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Enter a new password for ${widget.email}",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _newPasswordController,
              obscureText: obscureTextNew,
              onChanged: _checkPasswordCriteria,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      obscureTextNew = !obscureTextNew;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 28.0),
                    child: Icon(
                      obscureTextNew ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
                filled: true,
                fillColor: const Color(0XFFeef0f4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Colors.transparent, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Colors.transparent, width: 1),
                ),
                contentPadding:
                    const EdgeInsets.only(left: 28.0, top: 17, bottom: 17),
                labelText: 'New Password',
                labelStyle: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              obscureText: obscureTextConfirm,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      obscureTextConfirm = !obscureTextConfirm;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 28.0),
                    child: Icon(
                      obscureTextConfirm
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
                filled: true,
                fillColor: const Color(0XFFeef0f4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Colors.transparent, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Colors.transparent, width: 1),
                ),
                contentPadding:
                    const EdgeInsets.only(left: 28.0, top: 17, bottom: 17),
                labelText: 'Confirm Password',
                labelStyle: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 10),
            // Display password criteria
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Password must meet the following criteria:",
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 5),
                // Menampilkan kriteria dengan warna hijau atau merah
                Row(
                  children: [
                    Icon(
                      size: 14,
                      isLengthValid ? Icons.check_circle : Icons.cancel,
                      color: isLengthValid ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'At least 8 characters',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isLengthValid ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Icon(
                      size: 14,
                      isNumberValid ? Icons.check_circle : Icons.cancel,
                      color: isNumberValid ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Contains at least one number',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isNumberValid ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Icon(
                      size: 14,
                      (isUppercaseValid && isLowercaseValid)
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: (isUppercaseValid && isLowercaseValid)
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Contains both uppercase and lowercase letters',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: (isUppercaseValid && isLowercaseValid)
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Icon(
                      size: 14,
                      isSpecialCharacterValid
                          ? Icons.check_circle
                          : Icons.cancel,
                      color:
                          isSpecialCharacterValid ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'At least one special character',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color:
                            isSpecialCharacterValid ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _resetPassword,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF74B11A),
              ),
              child: _isLoading
                  ? const Text(
                      'Loading...',
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      'Reset Password',
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
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
