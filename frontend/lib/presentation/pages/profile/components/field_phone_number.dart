import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String? currentPhoneNumber;
  final ValueChanged<String>? onChanged;

  const PhoneNumberField({
    required this.controller,
    this.currentPhoneNumber,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'Enter Phone Number',
            hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            filled: true,
            fillColor: const Color(0xFFF0F1F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFF9FF421)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            contentPadding:
                const EdgeInsets.only(left: 28.0, top: 17, bottom: 17),
            labelText: 'Phone Number',
            labelStyle: GoogleFonts.poppins(color: Colors.grey),
            prefixIcon: const Icon(Icons.phone, color: Colors.grey),
            suffixIcon:
                currentPhoneNumber != null && currentPhoneNumber!.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          controller.clear();
                        },
                      )
                    : null,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Phone Number is required';
            } else if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
              return 'Enter a valid Phone Number';
            }
            return null;
          },
        ),
        // Display error message if validation fails
        if (controller.text.isNotEmpty &&
            !RegExp(r'^[0-9]*$').hasMatch(controller.text))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              'Enter a valid Phone Number',
              style: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
