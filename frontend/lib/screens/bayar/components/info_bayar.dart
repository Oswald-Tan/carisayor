import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoBayar extends StatelessWidget {
  const InfoBayar({super.key});

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
                color: Color(0xFF3E2961),
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(
                'Proses pembayaran Anda',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF3E2961),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Container(
            margin: const EdgeInsets.only(left: 21),
            child: Text(
              'Silahkan memilih dan sesuaikan nilai CS Poin pada transaksi Anda untuk pembayaran.',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF3E2961),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
