import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/core/api/config.dart';
import 'package:frontend/presentation/pages/loading_page.dart';
import 'package:frontend/presentation/pages/produk/components/adress.dart';
import 'package:frontend/presentation/pages/produk/components/order_confirmation.dart';
import 'package:frontend/presentation/pages/profile/components/alamat_saya.dart';
import 'package:frontend/data/services/address_service.dart';
import 'package:frontend/data/services/pesanan_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:frontend/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

final currencyFormat =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

String formatRupiah(int value) {
  return currencyFormat.format(value).replaceAll('Rp', 'Rp. ');
}

final Dio _dio = Dio();

class PaymentSelection extends StatefulWidget {
  static String routeName = "/paymentSelection";
  final String? id;
  final String nama;
  final int hargaRp;
  final int hargaPoin;
  final String imagePath;
  final int berat;
  final int beratNormal;
  final String satuan;

  const PaymentSelection({
    super.key,
    this.id,
    required this.nama,
    required this.hargaRp,
    required this.hargaPoin,
    required this.imagePath,
    required this.berat,
    required this.beratNormal,
    required this.satuan,
  });

  @override
  State<PaymentSelection> createState() => _PaymentSelectionState();
}

class _PaymentSelectionState extends State<PaymentSelection> {
  bool hasDefaultAddress = false;

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

  void _bayarDenganCOD(context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;
    // int ongkir = 10000;

    final address = await AddressService().getDefaultAddress(context, userId);

    // Update state untuk mengecek keberadaan alamat
    setState(() {
      hasDefaultAddress = address != null;
    });

    int ongkir = address?.shippingRate?.price ?? 0; // Default 0 jika null

    int totalBayar;
    if (widget.satuan.toLowerCase() == 'ikat') {
      totalBayar = widget.hargaRp * widget.berat;
    } else if (widget.satuan.toLowerCase() == 'gram') {
      totalBayar = (widget.berat / 100).ceil() * widget.hargaRp;
    } else if (widget.satuan.toLowerCase() == 'kilogram') {
      double beratInKilogram = widget.berat.toDouble();
      totalBayar = (beratInKilogram * widget.hargaRp).toInt();
    } else {
      totalBayar = 0;
    }

    int totalBayarSemua = totalBayar + ongkir;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true, // Pastikan ini aktif
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Wrap(
            // Gunakan Wrap agar konten menyesuaikan tinggi
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min, // Pastikan ini min
                children: [
                  Text(
                    'Pembayaran COD',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: const Color(0xFF1F2131),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Harga Produk",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1F2131),
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        formatRupiah(totalBayar),
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1F2131),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ongkir",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1F2131),
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        formatRupiah(ongkir),
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1F2131),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Color(0xFFE2E3E6), thickness: 1),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Bayar",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1F2131),
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        formatRupiah(totalBayarSemua),
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1F2131),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0x23FFC875),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Color(0xFFFF9A01),
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Pastikan alamat Anda sudah sesuai!',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: const Color(0xFFFF9A01),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Address Section
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFFF0F1F5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Shipping Address',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddressPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Change',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF74B11A),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          AddressWidget(userId: userId ?? 0),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: hasDefaultAddress
                        ? () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              useRootNavigator: true,
                              builder: (context) => const LoadingPage(),
                            );
                            // Tunda eksekusi selama 2 detik
                            await Future.delayed(const Duration(seconds: 2));
                            try {
                              String invoiceNumber =
                                  'INV-${DateTime.now().millisecondsSinceEpoch}';

                              // Buat data items
                              List<Map<String, dynamic>> items = [
                                {
                                  'productId': widget.id,
                                  'namaProduk': widget.nama,
                                  'harga': widget.hargaRp,
                                  'jumlah': widget.berat,
                                  'satuan': widget.satuan,
                                  'totalHarga': totalBayar,
                                },
                              ];

                              bool berhasil =
                                  await PesananService().bayarDenganCOD(
                                context,
                                totalBayar,
                                ongkir,
                                totalBayarSemua,
                                invoiceNumber,
                                items,
                              );

                              // Tutup loading
                              Navigator.of(context, rootNavigator: true).pop();

                              if (berhasil && context.mounted) {
                                // Tutup bottom sheet
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderConfirmationPage(
                                      namaProduk: widget.nama,
                                      jumlah: '${widget.berat}',
                                      satuan: widget.satuan,
                                      beratNormal: widget.beratNormal,
                                      hargaProduk: formatRupiah(widget.hargaRp),
                                      ongkir: formatRupiah(ongkir),
                                      totalBayar: formatRupiah(totalBayar),
                                      totalBayarSemua:
                                          formatRupiah(totalBayarSemua),
                                      invoiceNumber: invoiceNumber,
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              // Tutup loading
                              Navigator.of(context, rootNavigator: true).pop();
                              debugPrint('Error: $e');

                              Fluttertoast.showToast(
                                msg: 'Gagal memproses pesanan: $e',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 14.0,
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF74B11A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Pesan Sekarang',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _bayarDenganPoin(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;
    // final hargaPoinSet = await getHargaPoin(context) ?? 1;
    // int ongkir = (nilaiOngkir / hargaPoinSet).ceil();
    // int nilaiOngkir = 10000;
    // int ongkir = (nilaiOngkir / 1000).ceil();

    final address = await AddressService().getDefaultAddress(context, userId);

    // Update state untuk mengecek keberadaan alamat
    setState(() {
      hasDefaultAddress = address != null;
    });

    // Ambil harga ongkir dari shippingRate dan bulatkan ke atas (ceil)
    int ongkir = ((address?.shippingRate?.price ?? 0) / 1000).ceil();

    // Hitung total bayar berdasarkan satuan dan harga poin
    int totalBayar;
    if (widget.satuan.toLowerCase() == 'ikat') {
      totalBayar = widget.hargaPoin * widget.berat;
    } else if (widget.satuan.toLowerCase() == 'gram') {
      totalBayar = (widget.berat / 100).ceil() * widget.hargaPoin;
    } else if (widget.satuan.toLowerCase() == 'kilogram') {
      double beratInKilogram = widget.berat.toDouble();
      totalBayar = (beratInKilogram * widget.hargaPoin).toInt();
    } else {
      totalBayar = 0;
    }

    int totalBayarSemua = totalBayar + ongkir;
    debugPrint('total bayar semua: $totalBayarSemua');

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Pembayaran POIN',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color(0xFF1F2131),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Harga Produk",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF1F2131),
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/poin_cs.png',
                        width: 16,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '$totalBayar',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1F2131),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ongkir",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF1F2131),
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/poin_cs.png',
                        width: 16,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '$ongkir',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1F2131),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(color: Color(0xFFE2E3E6), thickness: 1),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Bayar",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF1F2131),
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/poin_cs.png',
                        width: 16,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '$totalBayarSemua',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1F2131),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0x23FFC875),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(0xFFFF9A01),
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Pastikan alamat Anda sudah sesuai!',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: const Color(0xFFFF9A01),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFF0F1F5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Shipping Address',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddressPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Change',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF74B11A),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      AddressWidget(userId: userId ?? 0),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: hasDefaultAddress
                    ? () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          useRootNavigator: true,
                          builder: (context) => const LoadingPage(),
                        );
                        // Tunda eksekusi selama 2 detik
                        await Future.delayed(const Duration(seconds: 2));
                        try {
                          String invoiceNumber =
                              'INV-${DateTime.now().millisecondsSinceEpoch}';

                          // Buat data items
                          List<Map<String, dynamic>> items = [
                            {
                              'productId': widget.id,
                              'namaProduk': widget.nama,
                              'harga': widget.hargaPoin,
                              'jumlah': widget.berat,
                              'satuan': widget.satuan,
                              'totalHarga': totalBayar,
                            },
                          ];

                          bool berhasil =
                              await PesananService().bayarDenganPoin(
                            context,
                            totalBayar,
                            ongkir,
                            totalBayarSemua,
                            invoiceNumber,
                            items,
                          );

                          // Tutup loading
                          Navigator.of(context, rootNavigator: true).pop();

                          // Jika pesanan berhasil, arahkan ke halaman sukses
                          if (berhasil) {
                            // Tutup bottom sheet
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderConfirmationPage(
                                  namaProduk: widget.nama,
                                  jumlah: '${widget.berat}',
                                  satuan: widget.satuan,
                                  beratNormal: widget.beratNormal,
                                  hargaProduk: '${widget.hargaPoin}',
                                  ongkir: '$ongkir',
                                  totalBayar: '$totalBayar',
                                  totalBayarSemua: '$totalBayarSemua',
                                  invoiceNumber: invoiceNumber,
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          // Tutup loading
                          Navigator.of(context, rootNavigator: true).pop();
                          debugPrint('Error: $e');
                          Fluttertoast.showToast(
                            msg: 'Gagal memproses pesanan: $e',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 14.0,
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF74B11A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Pesan Sekarang',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalBayarPoin;
    if (widget.satuan.toLowerCase() == 'ikat') {
      totalBayarPoin = widget.hargaPoin * widget.berat;
    } else if (widget.satuan.toLowerCase() == 'gram') {
      totalBayarPoin = (widget.berat / 100).ceil() * widget.hargaPoin;
    } else if (widget.satuan.toLowerCase() == 'kilogram') {
      double beratInKilogram = widget.berat.toDouble();
      totalBayarPoin = (beratInKilogram * widget.hargaPoin).toInt();
    } else {
      totalBayarPoin = 0;
    }

    int totalHargaRp;
    if (widget.satuan.toLowerCase() == 'ikat') {
      totalHargaRp = widget.hargaRp * widget.berat;
    } else if (widget.satuan.toLowerCase() == 'gram') {
      totalHargaRp = (widget.berat / 100).ceil() * widget.hargaRp;
    } else if (widget.satuan.toLowerCase() == 'kilogram') {
      double beratInKilogram = widget.berat.toDouble();
      totalHargaRp = (beratInKilogram * widget.hargaRp).toInt();
    } else {
      totalHargaRp = 0;
    }

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'Payment',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2131),
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF0F1F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
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
                      child: widget.imagePath.startsWith('http')
                          ? Image.network(
                              widget.imagePath,
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
                              widget.imagePath,
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
                                widget.nama,
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
                                    '${widget.hargaPoin}',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: const Color(0xFF1F2131),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                formatRupiah(widget.hargaRp),
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${widget.berat} ${widget.satuan == "Kilogram" ? "Kg" : widget.satuan == "Gram" ? "gram" : widget.satuan}',
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
                            fontWeight: FontWeight.w600,
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
                        fontWeight: FontWeight.w600,
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
