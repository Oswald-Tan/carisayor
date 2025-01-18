import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BayarScreen extends StatelessWidget {
  final String nama;
  final int harga;

  const BayarScreen({
    super.key,
    required this.nama,
    required this.harga,
  });

  void _showInvoice(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Invoice Pembayaran',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Produk: $nama', style: GoogleFonts.poppins()),
              const SizedBox(height: 8),
              Row(
                children: [
                  Image.asset('assets/images/poin_cs.png', width: 18),
                  const SizedBox(width: 8),
                  Text('Harga: $harga', style: GoogleFonts.poppins()),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Image.asset('assets/images/poin_cs.png', width: 18),
                  const SizedBox(width: 8),
                  Text('Total Poin yang Dimiliki: 0',
                      style: GoogleFonts.poppins()),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Poin yang dibutuhkan: $harga',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Lanjutkan Pembayaran
              },
              child: const Text('Lanjutkan Pembayaran'),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(BuildContext context, String title, String message,
      {bool isError = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: isError ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'Bayar $nama',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2131),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF1F2131),
            size: 14,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFFF0F1F5),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Harga $nama: ',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(
                    'assets/images/poin_cs.png',
                    width: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$harga',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showInvoice(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF589400),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Bayar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
