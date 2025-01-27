import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextfieldUsernameWidget extends StatefulWidget {
  const TextfieldUsernameWidget({Key? key, required this.controller});

  final TextEditingController controller;

  @override
  State<TextfieldUsernameWidget> createState() =>
      _TextfieldUsernameWidgetState();
}

class _TextfieldUsernameWidgetState extends State<TextfieldUsernameWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            controller: widget.controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null; // No error message when the field is empty
              } else if (value.length < 4) {
                return 'Username must be at least 4 characters long';
              }
              return null;
            },
            decoration: InputDecoration(
              // hintText: 'Enter your username',
              // hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              suffixIcon: const Padding(
                padding: EdgeInsets.only(right: 28.0),
                child: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
              ),
              contentPadding:
                  const EdgeInsets.only(left: 28.0, top: 17, bottom: 17),
              labelText: 'Username',
              labelStyle: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
