import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFF1F2131),
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Top Up Anda dalam proses',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: const Color(0xFF1F2131)),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Container(
                  margin: const EdgeInsets.only(left: 21),
                  child: Text.rich(
                    TextSpan(
                      text:
                          'Jika Anda ingin membatalkan Top Up, silahkan klik batal pada icon berwarna ',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: const Color(0xFF1F2131)),
                      children: [
                        TextSpan(
                          text: 'merah.',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFF1F2131),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
