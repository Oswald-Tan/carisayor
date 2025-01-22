import 'package:flutter/material.dart';
import 'package:frontend/screens/produk/components/pesanan_selection.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

final currencyFormat =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

class BuyNowModal extends StatefulWidget {
  final String? id;
  final String nama;
  final int hargaRp;
  final int hargaPoin;
  final String imagePath;
  final int berat;
  final String satuan;

  const BuyNowModal({
    super.key,
    this.id,
    required this.nama,
    required this.hargaRp,
    required this.hargaPoin,
    required this.imagePath,
    required this.berat,
    required this.satuan,
  });

  @override
  _BuyNowModalState createState() => _BuyNowModalState();
}

class _BuyNowModalState extends State<BuyNowModal> {
  late int productQuantity; // Variabel untuk berat produk

  @override
  void initState() {
    super.initState();
    productQuantity = widget.berat; // Mengambil nilai berat awal dari widget
  }

  // Fungsi untuk menambah atau mengurangi berat produk
  void _updateQuantity(bool increase) {
    setState(() {
      if (widget.satuan.toLowerCase() == "gram") {
        //jika satua gram, tambahkan atau kurangi kelipatan 100
        if (increase) {
          productQuantity += 100;
        } else if (productQuantity > 100) {
          productQuantity -= 100;
        }
      } else if (widget.satuan.toLowerCase() == "kilogram") {
        //jika satuan kilogram, tambahkan atau kurangi 1
        if (increase) {
          productQuantity += 1;
        } else if (productQuantity > 1) {
          productQuantity -= 1;
        }
      } else if (widget.satuan.toLowerCase() == "ikat") {
        //jika satuan ikat, tambahkan atau kurangi 1
        if (increase) {
          productQuantity += 1;
        } else if (productQuantity > 1) {
          productQuantity -= 1;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Menampilkan gambar produk
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xFFF0F1F5),
                    borderRadius: BorderRadius.circular(16)),
                child: widget.imagePath.startsWith('http')
                    ? Image.network(
                        widget.imagePath,
                        width: 110,
                        height: 110,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/placeholder.png',
                            width: 110,
                            height: 110,
                          );
                        },
                      )
                    : Image.asset(
                        widget.imagePath,
                        width: 110,
                        height: 110,
                      ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nama,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/poin_cs.png',
                        width: 18,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${widget.hargaPoin}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: const Color(0xFF1F2131),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    currencyFormat
                        .format(widget.hargaRp), // hargaRp ditampilkan
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Color(0xFFE6E7E9), // Warna garis
            thickness: 1, // Ketebalan garis
          ),
          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Quantity",
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Kontrol jumlah produk (plus/minus) yang berada di kanan
              Row(
                mainAxisAlignment: MainAxisAlignment.end, // Pindahkan ke kanan
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _updateQuantity(false),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF589400),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: const Icon(
                        Icons.remove,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$productQuantity ${widget.satuan == "Kilogram" ? "Kg" : widget.satuan == "Gram" ? "gram" : widget.satuan}', // Menampilkan berat produk
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => _updateQuantity(true),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF589400),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: const Icon(
                        Icons.add,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),
          // Tombol untuk checkout atau membeli
          ElevatedButton(
            onPressed: () {
              //navigasi ke halaman payment selection
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentSelection(
                    id: widget.id,
                    nama: widget.nama,
                    hargaRp: widget.hargaRp,
                    hargaPoin: widget.hargaPoin,
                    imagePath: widget.imagePath,
                    berat: productQuantity,
                    beratNormal: widget.berat,
                    satuan: widget.satuan,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF589400),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(
              'Beli Sekarang',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
