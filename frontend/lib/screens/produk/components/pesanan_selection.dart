import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/api/config.dart';
import 'package:frontend/screens/produk/components/adress.dart';
import 'package:frontend/screens/produk/components/order_confirmation.dart';
import 'package:frontend/services/pesanan_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';

final currencyFormat =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

String formatRupiah(int value) {
  return currencyFormat.format(value).replaceAll('Rp', 'Rp. ');
}

final Dio _dio = Dio();

class PaymentSelection extends StatelessWidget {
  final String nama;
  final int hargaRp;
  final int hargaPoin;
  final String imagePath;
  final int berat;
  final int beratNormal;
  final String satuan;

  const PaymentSelection({
    super.key,
    required this.nama,
    required this.hargaRp,
    required this.hargaPoin,
    required this.imagePath,
    required this.berat,
    required this.beratNormal,
    required this.satuan,
  });

  Future<int?> getHargaPoin(BuildContext context) async {
    try {
      // Ambil token dari UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      if (token == null) {
        throw Exception('User not authenticated');
      }

      // Kirim request dengan token di header Authorization
      final response = await _dio.get(
        '$baseUrl/settings-app/harga-poin',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Menambahkan token ke header
          },
        ),
      );

      // Mengecek apakah status code dari response adalah 200 (OK)
      if (response.statusCode == 200) {
        debugPrint(
            'Response data: ${response.data}'); // Debug untuk memeriksa data yang diterima
        return response.data['hargaPoin'];
      } else {
        debugPrint('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  void _bayarDenganCOD(BuildContext context) async {
    int ongkir = 10000;
    // int totalBayar = (berat / 100).ceil() * hargaRp + ongkir;

    int totalBayar;
    if (satuan.toLowerCase() == 'ikat') {
      totalBayar = hargaRp * berat;
    } else if (satuan.toLowerCase() == 'gram') {
      totalBayar = (berat / 100).ceil() * hargaRp;
    } else if (satuan.toLowerCase() == 'kilogram') {
      double beratInKilogram = berat.toDouble();
      totalBayar = (beratInKilogram * hargaRp).toInt();
    } else {
      totalBayar = 0;
    }

    int totalBayarSemua = totalBayar + ongkir;
    debugPrint('total bayar semua: $totalBayarSemua');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            // height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Konfirmasi Pembayaran',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2131),
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                Text('COD',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 10),
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    final username = userProvider.username ?? 'User';
                    return Text(
                      username,
                      style: GoogleFonts.poppins(),
                    );
                  },
                ),
                Text('Nama Produk: $nama', style: GoogleFonts.poppins()),
                Text('Berat Normal: $beratNormal',
                    style: GoogleFonts.poppins()),
                Text('Jumlah: $berat $satuan', style: GoogleFonts.poppins()),
                Text('Harga Produk: ${formatRupiah(hargaRp)}',
                    style: GoogleFonts.poppins()),
                Text('Ongkir: ${formatRupiah(ongkir)}',
                    style: GoogleFonts.poppins()),
                const SizedBox(height: 20),
                Text(
                  'Total Bayar: ${formatRupiah(totalBayarSemua)}',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Batal',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2131),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () async {
                        try {
                          String nameWithWeight = '$nama ($berat $satuan)';
                          await PesananService().bayarDenganCOD(
                            context,
                            nameWithWeight,
                            hargaRp,
                            ongkir,
                            totalBayarSemua,
                          );

                          // Tutup dialog dan tampilkan notifikasi
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderConfirmationPage(
                                      namaProduk: nama,
                                      jumlah: '$berat',
                                      satuan: satuan,
                                      beratNormal: beratNormal,
                                      hargaProduk: formatRupiah(hargaRp),
                                      ongkir: formatRupiah(ongkir),
                                      totalBayar: formatRupiah(totalBayar),
                                      totalBayarSemua:
                                          formatRupiah(totalBayarSemua),
                                    )),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Pesanan berhasil diproses')),
                          );
                        } catch (e) {
                          debugPrint('Error: $e');
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Gagal memproses pesanan: $e')),
                          );
                        }
                      },
                      child: Text(
                        'Ya',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2131),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _bayarDenganPoin(BuildContext context) async {
    // final hargaPoinSet = await getHargaPoin(context) ?? 1;
    int nilaiOngkir = 10000;
    // int ongkir = (nilaiOngkir / hargaPoinSet).ceil();
    int ongkir = (nilaiOngkir / 1000).ceil();

    // Hitung total bayar berdasarkan satuan dan harga poin
    int totalBayar;
    if (satuan.toLowerCase() == 'ikat') {
      totalBayar = hargaPoin * berat;
    } else if (satuan.toLowerCase() == 'gram') {
      totalBayar = (berat / 100).ceil() * hargaPoin;
    } else if (satuan.toLowerCase() == 'kilogram') {
      double beratInKilogram = berat.toDouble();
      totalBayar = (beratInKilogram * hargaPoin).toInt();
    } else {
      totalBayar = 0;
    }

    int totalBayarSemua = totalBayar + ongkir;
    debugPrint('total bayar semua: $totalBayarSemua');

    // Tampilkan dialog konfirmasi pembayaran
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            'Konfirmasi Pembayaran',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2131),
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Poin',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 10),
              Text('Nama Produk: $nama', style: GoogleFonts.poppins()),
              Text('Jumlah: ${berat} ${satuan}', style: GoogleFonts.poppins()),
              Text('Harga Produk: $hargaPoin', style: GoogleFonts.poppins()),
              Text('Total Harga Produk: $totalBayar',
                  style: GoogleFonts.poppins()),
              Text('Ongkir: $ongkir', style: GoogleFonts.poppins()),
              const SizedBox(height: 20),
              Text(
                'Total Bayar + Ongkir: $totalBayarSemua Poin',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2131),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  String nameWithWeight = '$nama ($berat $satuan)';
                  await PesananService().bayarDenganPoin(
                    context,
                    nameWithWeight,
                    hargaPoin,
                    ongkir,
                    totalBayarSemua,
                  );

                  // Navigasi hanya jika pembayaran berhasil
                  Navigator.pop(context); // Tutup dialog sebelum navigasi
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderConfirmationPage(
                              namaProduk: nama,
                              jumlah: '$berat',
                              satuan: satuan,
                              beratNormal: beratNormal,
                              hargaProduk: '$hargaPoin',
                              ongkir: '$ongkir',
                              totalBayar: '$totalBayar',
                              totalBayarSemua: '$totalBayarSemua',
                            )),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pesanan berhasil diproses')),
                  );
                } catch (e) {
                  debugPrint('Error: $e');
                  Navigator.pop(context); // Tutup dialog meskipun terjadi error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Gagal memproses pesanan: ${e.toString()}')),
                  );
                }
              },
              child: Text(
                'Ya',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2131),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalBayarPoin;
    if (satuan.toLowerCase() == 'ikat') {
      totalBayarPoin = hargaPoin * berat;
    } else if (satuan.toLowerCase() == 'gram') {
      totalBayarPoin = (berat / 100).ceil() * hargaPoin;
    } else if (satuan.toLowerCase() == 'kilogram') {
      double beratInKilogram = berat.toDouble();
      totalBayarPoin = (beratInKilogram * hargaPoin).toInt();
    } else {
      totalBayarPoin = 0;
    }

    int totalHargaRp;
    if (satuan.toLowerCase() == 'ikat') {
      totalHargaRp = hargaRp * berat;
    } else if (satuan.toLowerCase() == 'gram') {
      totalHargaRp = (berat / 100).ceil() * hargaRp;
    } else if (satuan.toLowerCase() == 'kilogram') {
      double beratInKilogram = berat.toDouble();
      totalHargaRp = (beratInKilogram * hargaRp).toInt();
    } else {
      totalHargaRp = 0;
    }

    final userProvider = Provider.of<UserProvider>(context);
    final userId = userProvider.userId;

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'Payment Produk',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2131),
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF0F1F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              AddressWidget(userId: userId ?? 0),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F1F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: imagePath.startsWith('http')
                          ? Image.network(
                              imagePath,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/placeholder.png',
                                  width: 50,
                                  height: 50,
                                );
                              },
                            )
                          : Image.asset(
                              imagePath,
                              width: 50,
                              height: 50,
                            ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nama,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/poin_cs.png',
                                    width: 14,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '$hargaPoin',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: const Color(0xFF1F2131),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                formatRupiah(hargaRp),
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$berat ${satuan == "Kilogram" ? "Kg" : satuan == "Gram" ? "gram" : satuan}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Poin",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/poin_cs.png',
                          width: 16,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '$totalBayarPoin',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Rupiah",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      formatRupiah(totalHargaRp), // Total harga dalam Rupiah
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Buttons layout with Row for left and right alignment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Button to choose COD on the left
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _bayarDenganCOD(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F2131),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.delivery_dining_outlined,
                          color: Color(0xFFFFFFFF),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'COD',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Button for paying with points on the right
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _bayarDenganPoin(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF589400),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.redeem_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Poin',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
