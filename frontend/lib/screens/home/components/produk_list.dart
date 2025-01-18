import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/screens/home/components/bayar_screen.dart';

class ProdukList extends StatelessWidget {
  final String nama;
  final int harga;
  final String imagePath;
  final String hargaRp;
  final int berat;

  const ProdukList({
    super.key,
    required this.nama,
    required this.harga,
    required this.imagePath,
    required this.hargaRp,
    required this.berat,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman bayar
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BayarScreen(nama: nama, harga: harga),
          ),
        );
      },
      child: Container(
        width: 200,
        height: 275,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F1F5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                imagePath,
                height: 150,
              ),
            ),
            const Spacer(), // Mendorong bagian nama hingga harga ke bawah
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/poin_cs.png',
                              width: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '$harga',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: const Color(0xFF1F2131),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              hargaRp,
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              '$berat gr',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: const Color(0xFF1F2131)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
