import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextfieldPhoneNumberWidget extends StatefulWidget {
  const TextfieldPhoneNumberWidget({Key? key, required this.controller});

  final TextEditingController controller;

  @override
  _TextfieldPhoneNumberWidgetState createState() =>
      _TextfieldPhoneNumberWidgetState();
}

class _TextfieldPhoneNumberWidgetState
    extends State<TextfieldPhoneNumberWidget> {
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
              return null; // No error message when the field is empty
            }
            // Add phone number validation logic if needed
            return null;
          },
          keyboardType: TextInputType.phone, // Set keyboard type to phone
          decoration: InputDecoration(
            // hintText: 'Enter your phone number',
            // hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide:
                  const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide:
                  const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.only(left: 28.0, top: 17, bottom: 17),
            labelText: 'Phone Number',
            labelStyle: GoogleFonts.poppins(color: Colors.grey),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 28),
              child: Icon(Icons.phone, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
