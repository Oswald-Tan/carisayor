import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Bayar extends StatefulWidget {
  final int totalValue;
  final int? selectedValue;
  final ValueChanged<int?> onValueChanged;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const Bayar({
    Key? key,
    required this.totalValue,
    required this.selectedValue,
    required this.onValueChanged,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  _BayarState createState() => _BayarState();
}

class _BayarState extends State<Bayar> {
  int transactionsTotal = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Poin CS Anda',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF1F2131),
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/poin_cs.png',
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '$transactionsTotal', // Ganti dengan transactionsTotal
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1F2131),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Image.asset(
                  'assets/images/cs.png',
                  width: 24,
                  height: 24,
                  color: const Color(0XFF74B11A),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF1F2131),
              ),
            ),
            Text(
              'Jumlah Poin',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2131),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
