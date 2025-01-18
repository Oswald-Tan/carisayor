import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/screens/home/components/bayar_screen.dart';

class BahanCard extends StatelessWidget {
  final String nama;
  final int harga;
  final String imagePath; // Tambahkan parameter untuk gambar produk

  const BahanCard({
    super.key,
    required this.nama,
    required this.harga,
    required this.imagePath, // Inisialisasi parameter gambar produk
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Image.asset(
          imagePath, // Menampilkan gambar dari imagePath
          width: 50,
          height: 40,
          fit: BoxFit.cover,
        ),
        title: Text(
          nama,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: const Color(0xFF1F2131),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
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
        onTap: () {
          // Navigasi ke halaman bayar
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BayarScreen(nama: nama, harga: harga),
            ),
          );
        },
      ),
    );
  }
}
