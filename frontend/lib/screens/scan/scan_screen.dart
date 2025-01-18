import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});
  static String routeName = "/scan";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'Scan',
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
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [Text('scan')],
          ),
        ),
      ),
    );
  }
}
