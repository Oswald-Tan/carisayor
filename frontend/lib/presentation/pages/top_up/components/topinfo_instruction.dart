import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopUpInfoInstruction extends StatelessWidget {
  const TopUpInfoInstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
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
                'Minimum top up amount: 100',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF1F2131),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Container(
            margin: const EdgeInsets.only(left: 21),
            child: Text.rich(
              TextSpan(
                text:
                    'Sekarang, pilih jumlah poin yang ingin Anda top up. Setelah itu, klik tombol ',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF1F2131),
                ),
                children: [
                  TextSpan(
                    text: 'Proses',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF1F2131),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: ' untuk melanjutkan proses top up.',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF1F2131),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
