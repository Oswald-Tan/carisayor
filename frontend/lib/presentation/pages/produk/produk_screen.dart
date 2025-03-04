import 'package:flutter/material.dart';
import 'package:frontend/core/api/config.dart';
import 'package:frontend/data/model/produk_model.dart';
import 'package:frontend/presentation/pages/produk/components/cart.dart';
import 'package:frontend/presentation/pages/produk/components/order_delivered.dart';
import 'package:frontend/presentation/pages/produk/components/order_page.dart';
import 'package:frontend/presentation/pages/produk/components/shimmer_produk_card.dart';
import 'package:frontend/presentation/pages/profile/components/alamat_saya.dart';
import 'package:frontend/data/services/cart_service.dart';
import 'package:frontend/data/services/produk_service.dart';
import 'package:frontend/presentation/pages/produk/components/produk_card.dart';
import 'package:frontend/presentation/pages/produk/components/search_bar_produk.dart';
import 'package:frontend/presentation/providers/cart_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend/presentation/providers/user_provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen> {
  String searchQuery = "";
  late Future<List<Produk>> _produkFuture;
  final ProdukService _produkService = ProdukService();
  final List<String> categories = [
    'All',
    'Vegetables',
    'Fruits',
    'Spices',
    'Seafood',
    'Meat_poultry',
    'Tubers'
  ];
  String selectedCategory = 'All';

  String _mapCategoryToDisplayText(String category) {
    switch (category) {
      case 'Meat_poultry':
        return 'Meat & Poultry';
      default:
        return category;
    }
  }

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
      int count = await CartService().getCartItemCount(context);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.setCartItemCount(count);
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

  void _showTimeoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 50,
              ),
              const SizedBox(height: 20),
              Text(
                'Connection Timeout',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'The connection timed out. Please check your internet connection and try again.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _loadProduk();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFF74B11A),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Try Again',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFFF0F1F5),
      //   title: Text(
      //     'Produk',
      //     style: GoogleFonts.poppins(
      //       fontWeight: FontWeight.w600,
      //       fontSize: 16,
      //     ),
      //   ),
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      // ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Ganti dengan SearchBarProduk
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: SearchBarProduk(
              onSearchChanged: _onSearchChanged,
              onCartPressed: _onCartPressed,
              cartItemCount: cartProvider.cartItemCount,
            ),
          ),
          // Padding(
          //   padding:
          //       const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 2),
          //   child: Row(
          //     children: [
          //       // Card pertama dengan Expanded
          //       Expanded(
          //         child: Container(
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(10),
          //             border: Border.all(
          //               color: const Color(0xFFF0F1F5),
          //             ),
          //           ),
          //           padding: const EdgeInsets.all(12),
          //           child: Column(
          //             children: [
          //               Center(
          //                 child: InkWell(
          //                   onTap: () {
          //                     Navigator.push(
          //                       context,
          //                       MaterialPageRoute(
          //                           builder: (context) =>
          //                               OrderPage(userId: userId ?? 0)),
          //                     );
          //                   },
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       const Icon(
          //                         Icons.delivery_dining_outlined,
          //                         color: Color(0xFFF9B32D),
          //                         size: 16,
          //                       ),
          //                       const SizedBox(width: 5),
          //                       Text(
          //                         'Orders',
          //                         style: GoogleFonts.poppins(
          //                           fontSize: 12,
          //                           fontWeight: FontWeight.w600,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 5),
          //       Expanded(
          //         child: Container(
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(10),
          //             border: Border.all(
          //               color: const Color(0xFFF0F1F5),
          //             ),
          //           ),
          //           padding: const EdgeInsets.all(12),
          //           child: Column(
          //             children: [
          //               Center(
          //                 child: InkWell(
          //                   onTap: () {
          //                     Navigator.push(
          //                       context,
          //                       MaterialPageRoute(
          //                           builder: (context) => OrderDeliveredPage(
          //                               userId: userId ?? 0)),
          //                     );
          //                   },
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       const Icon(
          //                         Icons.local_shipping_outlined,
          //                         color: Color(0xFFABCF51),
          //                         size: 16,
          //                       ),
          //                       const SizedBox(width: 5),
          //                       Text(
          //                         'Delivered',
          //                         style: GoogleFonts.poppins(
          //                           fontSize: 12,
          //                           fontWeight: FontWeight.w600,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 5),
          //       Expanded(
          //         child: Container(
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(10),
          //             border: Border.all(
          //               color: const Color(0xFFF0F1F5),
          //             ),
          //           ),
          //           padding: const EdgeInsets.all(12),
          //           child: Column(
          //             children: [
          //               Center(
          //                 child: InkWell(
          //                   onTap: () {
          //                     Navigator.push(
          //                       context,
          //                       MaterialPageRoute(
          //                           builder: (context) => const AddressPage()),
          //                     );
          //                   },
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       const Icon(
          //                         Icons.location_on_outlined,
          //                         color: Color(0xFF51CFA9),
          //                         size: 16,
          //                       ),
          //                       const SizedBox(width: 5),
          //                       Text(
          //                         'Address',
          //                         style: GoogleFonts.poppins(
          //                           fontSize: 12,
          //                           fontWeight: FontWeight.w600,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          _buildCategoryFilter(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadProduk,
              color: const Color(0xFF74B11A),
              backgroundColor: Colors.white,
              child: FutureBuilder<List<Produk>>(
                future: _produkFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return GridView.builder(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 90),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.70,
                      ),
                      itemCount: 6, // Jumlah placeholder shimmer
                      itemBuilder: (context, index) {
                        return const ShimmerProdukCard();
                      },
                    );
                  } else if (snapshot.hasError &&
                      snapshot.error
                          .toString()
                          .contains('Connection timeout')) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _showTimeoutBottomSheet(context);
                    });
                    return const SizedBox.shrink();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    // Filter produk berdasarkan search query
                    final filteredProducts = snapshot.data!
                        .where((product) => product.nama
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList();

                    // Filter produk berdasarkan kategori yang dipilih
                    final categoryFilteredProducts = selectedCategory == 'All'
                        ? filteredProducts
                        : filteredProducts
                            .where((product) =>
                                product.kategori == selectedCategory)
                            .toList();

                    return categoryFilteredProducts.isEmpty
                        ? Center(
                            child: Text(
                            'No products found.',
                            style: GoogleFonts.poppins(color: Colors.grey),
                          ))
                        : GridView.builder(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 0, bottom: 90),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.70,
                            ),
                            itemCount: categoryFilteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = categoryFilteredProducts[index];
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

  Widget _buildCategoryFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
      child: Row(
        children: categories.map((category) {
          final displayText = _mapCategoryToDisplayText(category);
          return Padding(
            padding: const EdgeInsets.only(right: 5),
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedCategory = category;
                });
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: selectedCategory == category
                      ? const Color(0xFF74B11A)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selectedCategory == category
                        ? const Color(0xFF74B11A)
                        : const Color(0xFFF0F1F5),
                  ),
                ),
                child: Text(
                  displayText, // Gunakan teks yang sudah dipetakan
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: selectedCategory == category
                        ? Colors.white
                        : const Color(0xFF1F2131),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
