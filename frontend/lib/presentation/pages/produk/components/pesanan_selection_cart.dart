import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/core/api/config.dart';
import 'package:frontend/presentation/pages/loading_page.dart';
import 'package:frontend/presentation/pages/produk/components/adress.dart';
import 'package:frontend/presentation/pages/produk/components/order_confirmation_cart.dart';
import 'package:frontend/presentation/pages/profile/components/alamat_saya.dart';
import 'package:frontend/data/services/address_service.dart';
import 'package:frontend/data/services/pesanan_service.dart';
import 'package:intl/intl.dart';
import 'package:frontend/data/model/cart_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

final currencyFormat =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

String formatRupiah(int value) {
  return currencyFormat.format(value).replaceAll('Rp', 'Rp. ');
}

final Dio _dio = Dio();

class PaymentSelectionCart extends StatefulWidget {
  final List<CartItem> selectedProducts;
  final int totalHarga;
  final int totalPoin;

  const PaymentSelectionCart({
    super.key,
    required this.selectedProducts,
    required this.totalHarga,
    required this.totalPoin,
  });

  @override
  State<PaymentSelectionCart> createState() => _PaymentSelectionCartState();
}

class _PaymentSelectionCartState extends State<PaymentSelectionCart> {
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

  void bayarDenganCODCart(context, CartItem item) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;
    // int ongkir = 10000;

    final address = await AddressService().getDefaultAddress(context, userId);

    // Update state untuk mengecek keberadaan alamat
    setState(() {
      hasDefaultAddress = address != null;
    });

    int ongkir = address?.shippingRate?.price ?? 0; // Default 0 jika null

    int totalBayar = widget.totalHarga + ongkir;

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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    "Harga Produk",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF1F2131),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    formatRupiah(widget.totalHarga),
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
                          int id = widget.selectedProducts.first.product.id;
                          List<CartItem> cartItems = widget.selectedProducts;
                          String invoiceNumber =
                              'INV-${DateTime.now().millisecondsSinceEpoch}';
                          // String namesWithWeights =
                          //     cartItems.asMap().entries.map((entry) {
                          //   int index = entry.key;
                          //   CartItem item = entry.value;
                          //   return '${item.product.nameProduk} (${cartItems[index].berat} ${item.product.satuan})';
                          // }).join(', ');

                          List<Map<String, dynamic>> items =
                              cartItems.map((item) {
                            int totalHarga = 0;

                            if (item.product.satuan.toLowerCase() == 'gram') {
                              totalHarga = item.product.hargaRp *
                                  (item.berat / 100).ceil();
                            } else if (item.product.satuan.toLowerCase() ==
                                'kilogram') {
                              totalHarga = item.product.hargaRp * item.berat;
                            } else if (item.product.satuan.toLowerCase() ==
                                'ikat') {
                              totalHarga = item.product.hargaRp * item.berat;
                            } else {
                              totalHarga = item.product.hargaRp * item.berat;
                            }

                            return {
                              'productId': item.product.id.toString(),
                              'namaProduk': item.product.nameProduk,
                              'harga': item.product.hargaRp,
                              'jumlah': item.berat,
                              'satuan': item.product.satuan,
                              'totalHarga': totalHarga,
                            };
                          }).toList();

                          bool berhasil =
                              await PesananService().bayarDenganCODCart(
                            context,
                            id.toString(),
                            // namesWithWeights,
                            widget.totalHarga,
                            ongkir,
                            totalBayar,
                            invoiceNumber,
                            items,
                          );

                          // Tutup loading
                          Navigator.of(context, rootNavigator: true).pop();

                          if (berhasil) {
                            // Tutup bottom sheet
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderConfirmationCartPage(
                                  namaProduk:
                                      widget.selectedProducts.map((item) {
                                    return '${item.product.nameProduk} (${item.product.jumlah} ${item.product.satuan})';
                                  }).toList(),
                                  jumlah: widget.selectedProducts
                                      .map((item) => item.berat.toString())
                                      .toList(),
                                  satuan: widget
                                      .selectedProducts.first.product.satuan,
                                  hargaProduk:
                                      widget.selectedProducts.map((item) {
                                    return formatRupiah(item.product.hargaRp);
                                  }).toList(),
                                  totalHarga: formatRupiah(widget.totalHarga),
                                  ongkir: formatRupiah(ongkir),
                                  totalBayar: formatRupiah(totalBayar),
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

  void bayarDenganPoinCart(context, CartItem item) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;
    // final hargaPoinSet = await getHargaPoin(context) ?? 1;
    // int ongkir = 10000;
    // int ongkirDalamPoin = (ongkir / hargaPoinSet).ceil();
    // int ongkirDalamPoin = (ongkir / 1000).ceil();
    // int totalBayar = totalPoin + ongkirDalamPoin;
    // debugPrint('$ongkirDalamPoin');

    final address = await AddressService().getDefaultAddress(context, userId);

    // Update state untuk mengecek keberadaan alamat
    setState(() {
      hasDefaultAddress = address != null;
    });

    // Ambil harga ongkir dari shippingRate dan bulatkan ke atas (ceil)
    int ongkir = (address?.shippingRate?.price ?? 0);
    int ongkirDalamPoin = (ongkir / 1000).ceil();
    int totalBayar = widget.totalPoin + ongkirDalamPoin;

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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        '${widget.totalPoin}',
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
                        '$ongkirDalamPoin',
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
                          int id = widget.selectedProducts.first.product.id;
                          List<CartItem> cartItems = widget.selectedProducts;
                          String invoiceNumber =
                              'INV-${DateTime.now().millisecondsSinceEpoch}';

                          List<Map<String, dynamic>> items =
                              cartItems.map((item) {
                            int totalHarga = 0;

                            if (item.product.satuan.toLowerCase() == 'gram') {
                              totalHarga = item.product.hargaPoin *
                                  (item.berat / 100).ceil();
                            } else if (item.product.satuan.toLowerCase() ==
                                'kilogram') {
                              totalHarga = item.product.hargaPoin * item.berat;
                            } else if (item.product.satuan.toLowerCase() ==
                                'ikat') {
                              totalHarga = item.product.hargaPoin * item.berat;
                            } else {
                              totalHarga = item.product.hargaPoin * item.berat;
                            }

                            return {
                              'productId': item.product.id.toString(),
                              'namaProduk': item.product.nameProduk,
                              'harga': item.product.hargaPoin,
                              'jumlah': item.berat,
                              'satuan': item.product.satuan,
                              'totalHarga': totalHarga,
                            };
                          }).toList();

                          // Cek apakah poin cukup terlebih dahulu
                          bool berhasil =
                              await PesananService().bayarDenganPoinCart(
                            context,
                            id.toString(),
                            widget.totalPoin,
                            ongkirDalamPoin,
                            totalBayar,
                            invoiceNumber,
                            items,
                          );

                          // Tutup loading
                          Navigator.of(context, rootNavigator: true).pop();

                          // Navigasi hanya jika pembayaran berhasil
                          if (berhasil && context.mounted) {
                            // Tutup bottom sheet
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OrderConfirmationCartPage(
                                        namaProduk:
                                            widget.selectedProducts.map((item) {
                                          return '${item.product.nameProduk} (${item.product.jumlah} ${item.product.satuan})';
                                        }).toList(),
                                        jumlah: widget.selectedProducts
                                            .map(
                                                (item) => item.berat.toString())
                                            .toList(),
                                        satuan: widget.selectedProducts.first
                                            .product.satuan,
                                        hargaProduk:
                                            widget.selectedProducts.map((item) {
                                          return '${item.product.hargaPoin}';
                                        }).toList(),
                                        totalHarga: '${widget.totalPoin}',
                                        ongkir: '$ongkirDalamPoin',
                                        totalBayar: '$totalBayar',
                                        invoiceNumber: invoiceNumber,
                                      )),
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
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text('Payment',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2131),
              fontSize: 16,
            )),
      ),
      backgroundColor: const Color(0xFFF0F1F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 200 - 150,
              child: ListView.builder(
                itemCount: widget.selectedProducts.length,
                itemBuilder: (context, index) {
                  final item = widget.selectedProducts[index];
                  final imageUrl = (item.product.image != null &&
                          item.product.image!.startsWith('http'))
                      ? item.product.image!
                      : '$baseUrlStatic/${item.product.image ?? 'placeholder.png'}';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F1F5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.network(
                            imageUrl,
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/placeholder.png',
                                width: 50,
                                height: 50,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Kolom untuk nameProduk, hargaRp, dan hargaPoin
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.nameProduk,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/poin_cs.png',
                                        width: 16,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${item.product.hargaPoin}',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: const Color(0xFF1F2131),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    currencyFormat.format(item.product.hargaRp),
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              // Teks jumlah di sebelah kanan
                              Text(
                                '${item.product.jumlah} ${item.product.satuan}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
                  );
                },
              ),
            ),
          ],
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
                          '${widget.totalPoin}',
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
                      formatRupiah(
                          widget.totalHarga), // Total harga dalam Rupiah
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
                      bayarDenganCODCart(
                          context, widget.selectedProducts.first);
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
                      bayarDenganPoinCart(
                          context, widget.selectedProducts.first);
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
