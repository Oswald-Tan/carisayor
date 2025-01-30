import 'package:flutter/material.dart';
import 'package:frontend/api/config.dart';
import 'package:frontend/model/produk_model.dart';
import 'package:frontend/screens/produk/components/cart.dart';
import 'package:frontend/services/cart_service.dart';
import 'package:frontend/services/produk_service.dart';
import 'package:frontend/screens/produk/components/produk_card.dart';
import 'package:frontend/screens/produk/components/search_bar_produk.dart'; // Import SearchBarProduk
import 'package:google_fonts/google_fonts.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String searchQuery = "";
  late Future<List<Produk>> _produkFuture;
  final ProdukService _produkService = ProdukService();
  int cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProduk();
    _updateCartItemCount();
  }

  // Method to load or reload products
  Future<void> _loadProduk() async {
    setState(() {
      _produkFuture = _produkService.fetchProduk(context);
    });

    await _updateCartItemCount();
  }

  //update cart item count
  Future<void> _updateCartItemCount() async {
    try {
      int count = await CartService().getCartItemCount(context, context);
      setState(() {
        cartItemCount = count;
      });
    } catch (e) {
      debugPrint('Error getting cart item count: $e');
    }
  }

  // Fungsi yang dijalankan ketika search berubah
  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  // Fungsi untuk menekan ikon keranjang
  void _onCartPressed() {
    // Navigasi ke halaman keranjang
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F1F5),
        title: Text(
          'Produk',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Ganti dengan SearchBarProduk
          SearchBarProduk(
            onSearchChanged: _onSearchChanged,
            onCartPressed: _onCartPressed,
            cartItemCount: cartItemCount,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadProduk,
              color: const Color(0xFF74B11A),
              child: FutureBuilder<List<Produk>>(
                future: _produkFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    final filteredProducts = snapshot.data!
                        .where((product) => product.nama
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList();

                    return filteredProducts.isEmpty
                        ? const Center(child: Text('No products found.'))
                        : GridView.builder(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 90),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.70,
                            ),
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              return ProdukCard(
                                id: product.id.toString(),
                                nama: product.nama,
                                hargaPoin: product.hargaPoin,
                                hargaRp: product.hargaRp,
                                berat: product.jumlah,
                                satuan: product.satuan,
                                imagePath: product.image != null
                                    ? '$baseUrlStatic/${product.image}'
                                    : 'assets/images/placeholder.png',
                                deskripsi: product.deskripsi,
                              );
                            },
                          );
                  } else {
                    return const Center(child: Text('No products found.'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
