import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/api/config.dart';
import 'package:frontend/screens/produk/components/adress.dart';
import 'package:frontend/screens/produk/components/order_confirmation_cart.dart';
import 'package:frontend/services/pesanan_service.dart';
import 'package:intl/intl.dart';
import 'package:frontend/model/cart_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

final currencyFormat =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

String formatRupiah(int value) {
  return currencyFormat.format(value).replaceAll('Rp', 'Rp. ');
}

final Dio _dio = Dio();

class PaymentSelectionCart extends StatelessWidget {
  final List<CartItem> selectedProducts;
  final int totalHarga;
  final int totalPoin;

  const PaymentSelectionCart({
    super.key,
    required this.selectedProducts,
    required this.totalHarga,
    required this.totalPoin,
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

  void bayarDenganCODCart(BuildContext context, CartItem item) async {
    int ongkir = 10000;

    int totalBayar = totalHarga + ongkir;

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
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Text('Nama Produk:', style: GoogleFonts.poppins()),
                Column(
                  children: selectedProducts.asMap().entries.map((entry) {
                    int index = entry.key;
                    var item = entry.value;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Nama Produk
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Text('${index + 1}. '),
                              Expanded(
                                child: Text(
                                  item.product.nameProduk,
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Berat Produk
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${selectedProducts[index].berat} ${item.product.satuan}',
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Text('Total Harga Produk: ${formatRupiah(totalHarga)}',
                    style: GoogleFonts.poppins()),
                Text('Ongkir: ${formatRupiah(ongkir)}',
                    style: GoogleFonts.poppins()),
                const SizedBox(height: 20),
                Text(
                  'Total Bayar: ${formatRupiah(totalBayar)}',
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
                          List<CartItem> cartItems = selectedProducts;
                          String namesWithWeights =
                              cartItems.asMap().entries.map((entry) {
                            int index = entry.key;
                            CartItem item = entry.value;
                            return '${item.product.nameProduk} (${cartItems[index].berat} ${item.product.satuan})';
                          }).join(', ');

                          await PesananService().bayarDenganCODCart(
                            context,
                            namesWithWeights,
                            totalHarga,
                            ongkir,
                            totalBayar,
                          );

                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderConfirmationCartPage(
                                namaProduk: selectedProducts.map((item) {
                                  return '${item.product.nameProduk} (${item.product.jumlah} ${item.product.satuan})';
                                }).toList(),
                                jumlah: selectedProducts
                                    .map((item) => item.berat.toString())
                                    .toList(),
                                satuan: selectedProducts.first.product.satuan,
                                hargaProduk: selectedProducts.map((item) {
                                  return '${formatRupiah(item.product.hargaRp)}';
                                }).toList(),
                                totalHarga: formatRupiah(totalHarga),
                                ongkir: formatRupiah(ongkir),
                                totalBayar: formatRupiah(totalBayar),
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Pesanan berhasil diproses')),
                          );
                        } catch (e) {
                          print('Error: $e');
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

  void bayarDenganPoinCart(BuildContext context, CartItem item) async {
    // final hargaPoinSet = await getHargaPoin(context) ?? 1;
    int ongkir = 10000;
    // int ongkirDalamPoin = (ongkir / hargaPoinSet).ceil();
    int ongkirDalamPoin = (ongkir / 1000).ceil();
    int totalBayar = totalPoin + ongkirDalamPoin;
    debugPrint('$ongkirDalamPoin');

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
              Text('Nama Produk: ', style: GoogleFonts.poppins()),
              Column(
                children: selectedProducts.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Nama Produk
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Text('${index + 1}. '),
                            Expanded(
                              child: Text(
                                item.product.nameProduk,
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Berat Produk
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${selectedProducts[index].berat} ${item.product.satuan}', // Ambil berat dari selectedProducts
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              Text('Total Harga Produk: ${totalPoin} Poin',
                  style: GoogleFonts.poppins()),
              Text(
                'Ongkir: $ongkirDalamPoin',
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 20),
              Text(
                'Total Bayar: ${totalBayar} Poin',
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
                  List<CartItem> cartItems = selectedProducts;
                  String namesWithWeights =
                      cartItems.asMap().entries.map((entry) {
                    int index = entry.key;
                    CartItem item = entry.value;
                    return '${item.product.nameProduk} (${cartItems[index].berat} ${item.product.satuan})';
                  }).join(', ');

                  await PesananService().bayarDenganPoinCart(
                    context,
                    namesWithWeights,
                    totalPoin,
                    ongkirDalamPoin,
                    totalBayar,
                  );

                  // Tutup dialog dan tampilkan notifikasi
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderConfirmationCartPage(
                        namaProduk: selectedProducts.map((item) {
                          return '${item.product.nameProduk} (${item.product.jumlah} ${item.product.satuan})';
                        }).toList(),
                        jumlah: selectedProducts
                            .map((item) => item.berat.toString())
                            .toList(),
                        satuan: selectedProducts.first.product.satuan,
                        hargaProduk: selectedProducts.map((item) {
                          return '${item.product.hargaPoin}';
                        }).toList(),
                        totalHarga: '$totalPoin',
                        ongkir: '$ongkirDalamPoin',
                        totalBayar: '$totalBayar',
                      ),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pesanan berhasil diproses')),
                  );
                } catch (e) {
                  debugPrint('Error: $e');
                  Navigator.pop(context);
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
    final userProvider = Provider.of<UserProvider>(context);
    final userId = userProvider.userId;

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text('Payment Produk',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2131),
              fontSize: 16,
            )),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF0F1F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AddressWidget(userId: userId ?? 0),
            const SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height - 200 - 150,
              child: ListView.builder(
                itemCount: selectedProducts.length,
                itemBuilder: (context, index) {
                  final item = selectedProducts[index];
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
                          '$totalPoin',
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
                      formatRupiah(totalHarga), // Total harga dalam Rupiah
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
                      bayarDenganCODCart(context, selectedProducts.first);
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
                      bayarDenganPoinCart(context, selectedProducts.first);
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
