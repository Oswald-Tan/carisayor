import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/screens/top_up/components/invoice_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ConfirmationModal extends StatelessWidget {
  final int selectedPoints;
  final int totalPrice;

  const ConfirmationModal({
    super.key,
    required this.selectedPoints,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("#,##0", "id_ID");

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Konten Modal Bottom Sheet
        FractionallySizedBox(
          widthFactor: 1.0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Top Up',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: const Color(0xFF1F2131),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top Up Amount",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/poin_cs.png',
                          width: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$selectedPoints ',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF1F2131),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(color: Color(0xFFE2E3E6), thickness: 1),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Payment Amount",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Rp. ${numberFormat.format(totalPrice)}',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF1F2131),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(color: Color(0xFFE2E3E6), thickness: 1),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Date",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      DateFormat('d MMMM, yyyy - hh:mm a')
                          .format(DateTime.now()),
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF1F2131),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(color: Color(0xFFE2E3E6), thickness: 1),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog
                    // Navigasi ke halaman invoice
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InvoicePage(
                          points: selectedPoints,
                          price: totalPrice,
                          date: DateTime.now(),
                          bankName: "BCA",
                          noHp: "1234567890",
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF74B11A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Confirm',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Lingkaran di atas modal
        Positioned(
          top: -40, // Posisi lingkaran di atas modal
          left: MediaQuery.of(context).size.width / 2 - 40, // Tengah
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF74B11A),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.circleExclamation,
                size: 38,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
