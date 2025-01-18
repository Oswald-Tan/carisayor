import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextfieldEmailWidget extends StatefulWidget {
  const TextfieldEmailWidget({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<TextfieldEmailWidget> createState() => _TextfieldEmailWidgetState();
}

class _TextfieldEmailWidgetState extends State<TextfieldEmailWidget> {
  final _emailValidator = RegExp(
    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-zA-Z]{2,})$',
  );

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
            } else if (!_emailValidator.hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
          decoration: InputDecoration(
            // hintText: 'Enter your email',
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
            labelText: 'Email',
            labelStyle: GoogleFonts.poppins(color: Colors.grey),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 28),
              child: Icon(Icons.email, color: Colors.grey),
            ), // Tambahkan baris ini
          ),
        ),
        const SizedBox(height: 10), // Add some space for better appearance
      ],
    );
  }
}
