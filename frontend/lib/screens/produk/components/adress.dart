import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Address extends StatelessWidget {
  const Address({super.key});

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
                Icons.location_on_outlined,
                color: Color(0xFF1F2131),
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(
                'Alamat',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color(0xFF1F2131),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Container(
            margin: const EdgeInsets.only(left: 21),
            child: Text(
              "Matungkas, Homeland Residence, Kec. Dimembe, Kab. Minahasa Utara, Sulawesi Utara.",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF1F2131),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
