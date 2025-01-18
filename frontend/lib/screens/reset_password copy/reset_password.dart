import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPasswordScreen extends StatefulWidget {
  static String routeName = "/reset_password";

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      // Simulasi reset password tanpa Firebase
      String email = _emailController.text.trim();

      // Logika reset password, misalnya mengirim email atau menyimpan ke server
      if (email.isNotEmpty) {
        Fluttertoast.showToast(
          msg: 'Link reset password telah dikirim ke $email',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } else {
        throw Exception('Email kosong');
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: 'Gagal mengirim reset password',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text(
            'Reset Password',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2131),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF1F2131),
              size: 14,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: const Color(0xFFF0F1F5),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  filled: true,
                  fillColor: const Color(0xFFF0F1F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color(0xFF74B11A)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding:
                      const EdgeInsets.only(left: 28.0, top: 17, bottom: 17),
                  labelText: 'Masukan Email',
                  labelStyle: GoogleFonts.poppins(color: Colors.grey),
                  prefixIcon:
                      const Icon(Icons.email_outlined, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: passwordReset,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF74B11A),
                ),
                child: Text(
                  'Reset Password',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
