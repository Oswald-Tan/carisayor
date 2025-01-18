import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/screens/init_screen.dart';

class PembayaranSuksesScreen extends StatelessWidget {
  const PembayaranSuksesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'Pembayaran Sukses',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2131),
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF0F1F5),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center content horizontally
          children: [
            Center(
              // Center the image horizontally
              child: Image.asset(
                "assets/images/success.png",
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: 10), // Space between image and text
            Text(
              'Pembayaran Anda berhasil!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const Spacer(), // Push the button to the bottom
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const InitScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF589400),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Back to home',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
