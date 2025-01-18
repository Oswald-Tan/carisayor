import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/screens/produk/components/detail_produk.dart';
import 'package:intl/intl.dart';

final currencyFormat =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

String formatRupiah(int value) {
  return currencyFormat.format(value).replaceAll('Rp', 'Rp. ');
}

class ProdukCard extends StatelessWidget {
  final String? id;
  final String nama;
  final int hargaPoin;
  final String imagePath;
  final int hargaRp;
  final int berat;
  final String satuan;
  final String deskripsi;

  const ProdukCard({
    super.key,
    this.id,
    required this.nama,
    required this.hargaPoin,
    required this.imagePath,
    required this.hargaRp,
    required this.berat,
    required this.satuan,
    required this.deskripsi,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to detail product screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProduk(
              id: id,
              nama: nama,
              hargaPoin: hargaPoin,
              hargaRp: hargaRp,
              berat: berat,
              satuan: satuan,
              imagePath: imagePath,
              deskripsi: deskripsi,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
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
                  child: imagePath.startsWith('http')
                      ? Image.network(
                          imagePath,
                          height: 140,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/placeholder.png',
                              height: 140,
                            );
                          },
                        )
                      : Image.asset(
                          imagePath,
                          height: 140,
                        ),
                ),
                const Spacer(),
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
                                const SizedBox(width: 2),
                                Text(
                                  '$hargaPoin',
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
                                  formatRupiah(hargaRp),
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  '$berat ${satuan == "Kilogram" ? "Kg" : satuan == "Gram" ? "gr" : satuan}',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: const Color(0xFF1F2131)),
                                ),
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
        ],
      ),
    );
  }
}
