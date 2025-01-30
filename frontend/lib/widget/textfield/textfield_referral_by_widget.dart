import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextfieldReferralCodeWidget extends StatefulWidget {
  const TextfieldReferralCodeWidget({super.key, required this.controller});

  final TextEditingController controller;

  @override
  _TextfieldReferralCodeWidgetState createState() =>
      _TextfieldReferralCodeWidgetState();
}

class _TextfieldReferralCodeWidgetState
    extends State<TextfieldReferralCodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              // Tidak ada validasi jika kosong (opsional)
              return null;
            }

            // Validasi panjang kode referral
            if (value.length < 6 || value.length > 10) {
              return 'Referral code must be 6-10 characters long.';
            }

            // Validasi format kode referral (hanya huruf dan angka)
            final regex = RegExp(r'^[a-zA-Z0-9]+$');
            if (!regex.hasMatch(value)) {
              return 'Referral code can only contain letters and numbers.';
            }

            return null; // Validasi berhasil
          },
          keyboardType: TextInputType.text, // Ubah ke text karena referral code
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: const Color(0XFFeef0f4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent, width: 1),
            ),
            contentPadding:
                const EdgeInsets.only(left: 28.0, top: 17, bottom: 17),
            labelText: 'Referral Code (Optional)',
            labelStyle: GoogleFonts.poppins(color: Colors.grey),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 28),
              child: Icon(
                Icons.card_giftcard,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
