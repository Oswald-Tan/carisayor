import 'package:flutter/material.dart';
import 'package:frontend/api/config.dart';
import 'package:frontend/model/cart_item.dart';
import 'package:frontend/screens/produk/components/pesanan_selection_cart.dart';
import 'package:frontend/services/cart_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';

final currencyFormat =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

String formatRupiah(int value) {
  return currencyFormat.format(value).replaceAll('Rp', 'Rp. ');
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<CartItem>> _cartItemsFuture;
  List<int> selectedProducts = [];
  bool selectAll = false;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  // Fungsi untuk memuat data keranjang
  void _loadCartItems() {
    _cartItemsFuture = CartService().getCartItems(context);
  }

  // Fungsi untuk refresh data
  Future<void> _refreshCartItems() async {
    setState(() {
      _loadCartItems();
      selectedProducts.clear(); // Hapus pilihan produk saat refresh
      selectAll = false;
    });
  }

  // Fungsi untuk menambah/menghapus produk ke daftar pilihan
  void _toggleProductSelection(int productId) {
    debugPrint('Product ID: $productId');
    setState(() {
      if (selectedProducts.contains(productId)) {
        selectedProducts.remove(productId); // Hapus jika sudah dipilih
      } else {
        selectedProducts.add(productId); // Tambahkan jika belum dipilih
      }
    });
  }

  // Fungsi untuk toggle select all produk
  void _toggleSelectAll(List<CartItem> cartItems) {
    setState(() {
      if (selectAll) {
        selectedProducts.clear();
      } else {
        selectedProducts = cartItems.map((item) => item.product.id).toList();
      }
      selectAll = !selectAll;
    });
  }

  // Fungsi untuk menghitung total poin dari produk yang dipilih
  int getTotalPoin(List<CartItem> cartItems) {
    int totalPoin = 0;
    for (var item in cartItems) {
      if (selectedProducts.contains(item.product.id)) {
        if (item.product.satuan == "Gram") {
          totalPoin += item.product.hargaPoin * (item.berat / 100).ceil();
        } else if (item.product.satuan == "Kilogram") {
          totalPoin += (item.berat * item.product.hargaPoin).toInt();
        } else if (item.product.satuan == "Ikat") {
          totalPoin += item.product.hargaPoin * item.berat;
        } else {
          totalPoin += item.product.hargaPoin * item.berat;
        }
      }
    }
    return totalPoin;
  }

  // Fungsi untuk menghitung total harga dari produk yang dipilih
  int getTotalHarga(List<CartItem> cartItems) {
    int totalHarga = 0;
    for (var item in cartItems) {
      if (selectedProducts.contains(item.product.id)) {
        if (item.product.satuan == "Gram") {
          totalHarga += item.product.hargaRp * (item.berat / 100).ceil();
        } else if (item.product.satuan == "Kilogram") {
          totalHarga += (item.berat * item.product.hargaRp).toInt();
        } else if (item.product.satuan == "Ikat") {
          totalHarga += item.product.hargaRp * item.berat;
        } else {
          totalHarga += item.product.hargaRp * item.berat;
        }
      }
    }
    return totalHarga;
  }

  void _updateProductQuantity(CartItem cartItem, bool isIncrement) async {
    final int originalBerat = cartItem.berat; // Simpan berat awal
    final int newBerat = isIncrement
        ? cartItem.berat + cartItem.product.jumlah
        : cartItem.berat > cartItem.product.jumlah
            ? cartItem.berat - cartItem.product.jumlah
            : cartItem.berat;

    setState(() {
      cartItem.berat = newBerat; // Perbarui UI langsung
    });

    try {
      await CartService().updateCartItem(
        context,
        cartItem.userId.toString(),
        cartItem.productId.toString(),
        newBerat,
      );
    } catch (e) {
      // Jika gagal, kembalikan ke nilai awal
      setState(() {
        cartItem.berat = originalBerat;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui berat produk.')),
      );

      debugPrint('Error updating cart item: $e');
    }
  }

  void _deleteCartItem(String cartId) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.userId;

      if (userId == null) {
        throw Exception('User ID not available');
      }

      // Konversi userId (int) ke String
      await CartService().deleteCartItem(context, userId.toString(), cartId);

      // Refresh data keranjang setelah item dihapus
      await _refreshCartItems();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item berhasil dihapus dari keranjang.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus item dari keranjang.')),
      );
      debugPrint('Error deleting cart item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context);
    // final userId = userProvider.userId;

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'Keranjang',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2131),
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                isEditMode = !isEditMode; // Toggle between Edit and Done mode
                if (!isEditMode) {
                  selectedProducts
                      .clear(); // Clear selection when exiting edit mode
                }
              });
            },
            child: Text(
              isEditMode ? 'Done' : 'Edit',
              style: GoogleFonts.poppins(
                color: const Color(0xFF589400),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF0F1F5),
      body: RefreshIndicator(
        onRefresh: _refreshCartItems, // Menjaga agar onRefresh berfungsi
        color: const Color(0xFF74B11A),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Daftar produk keranjang dengan RefreshIndicator
              Expanded(
                child: FutureBuilder<List<CartItem>>(
                  future: _cartItemsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Terjadi kesalahan: ${snapshot.error}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      );
                    } else {
                      List<CartItem> cartItems = snapshot.data!;

                      // Jika keranjang kosong, tampilkan teks "Tidak ada data"
                      if (cartItems.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.remove_shopping_cart_outlined,
                                size: 48.0,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Tidak ada data',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Render daftar item keranjang jika ada data
                      return ListView.builder(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.21),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data == [] || snapshot.data!.isEmpty) {
                            // Tampilan saat data kosong
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment
                                    .center, // Opsional, untuk memastikan horisontal juga center
                                children: [
                                  Text(
                                    'Tidak ada data',
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final cartItem = cartItems[index];
                          final product = cartItem.product;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Checkbox
                                GestureDetector(
                                  onTap: () {
                                    _toggleProductSelection(product.id);
                                  },
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          selectedProducts.contains(product.id)
                                              ? const Color(0xFF589400)
                                              : Colors.transparent,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    child: selectedProducts.contains(product.id)
                                        ? const Icon(
                                            Icons.check,
                                            size: 15,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Gambar produk
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F1F5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.network(
                                    '$baseUrlStatic/${product.image}',
                                    height: 50,
                                    width: 50,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.5,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/placeholder.png',
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Informasi produk
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.nameProduk,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/poin_cs.png',
                                            width: 15,
                                            height: 15,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            '${product.hargaPoin} / ${formatRupiah(product.hargaRp)}',
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          // Tombol Minus
                                          GestureDetector(
                                            onTap: () async {
                                              _updateProductQuantity(
                                                  cartItem, false);
                                              await CartService()
                                                  .updateCartItem(
                                                context,
                                                cartItems[index]
                                                    .userId
                                                    .toString(),
                                                cartItems[index]
                                                    .productId
                                                    .toString(),
                                                cartItems[index].berat,
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF589400),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              padding: const EdgeInsets.all(2),
                                              child: const Icon(
                                                Icons.remove,
                                                size: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          // Berat Produk
                                          Text(
                                            '${cartItems[index].berat} ${product.satuan == "Kilogram" ? "Kg" : product.satuan == "Gram" ? "gr" : product.satuan}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),

                                          const SizedBox(width: 5),
                                          // Tombol Plus
                                          GestureDetector(
                                            onTap: () async {
                                              _updateProductQuantity(
                                                  cartItem, true);
                                              await CartService()
                                                  .updateCartItem(
                                                context,
                                                cartItems[index]
                                                    .userId
                                                    .toString(),
                                                cartItems[index]
                                                    .productId
                                                    .toString(),
                                                cartItems[index].berat,
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF589400),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              padding: const EdgeInsets.all(2),
                                              child: const Icon(
                                                Icons.add,
                                                size: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: FutureBuilder<List<CartItem>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Tidak menampilkan bottom sheet jika data kosong
            return const SizedBox.shrink();
          } else {
            List<CartItem> cartItems = snapshot.data!;

            return Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _toggleSelectAll(
                              cartItems); // Panggil fungsi toggle select all
                        },
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectAll
                                ? const Color(0xFF589400)
                                : Colors
                                    .transparent, // Warna hijau jika selectAll aktif
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: selectAll
                              ? const Icon(
                                  Icons.check,
                                  size: 15,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Select All',
                        style: GoogleFonts.poppins(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Color(0xFFE9ECEF),
                    thickness: 1,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Poin:',
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
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
                            '${getTotalPoin(cartItems)}', // Total harga dalam Poin
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
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
                        'Total Harga:',
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        formatRupiah(getTotalHarga(cartItems)),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: selectedProducts.isEmpty
                        ? null
                        : () {
                            if (isEditMode) {
                              // Delete selected products from cart
                              for (var productId in selectedProducts) {
                                final cartItem = cartItems.firstWhere(
                                    (item) => item.product.id == productId);
                                _deleteCartItem(cartItem.id.toString());
                              }
                            } else {
                              // Navigasi ke halaman pembayaran
                              final List<CartItem> selectedCartItems = cartItems
                                  .where((item) => selectedProducts
                                      .contains(item.product.id))
                                  .toList();

                              final int totalHarga = getTotalHarga(cartItems);
                              final int totalPoin = getTotalPoin(cartItems);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentSelectionCart(
                                    selectedProducts: selectedCartItems,
                                    totalHarga: totalHarga,
                                    totalPoin: totalPoin,
                                  ),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFF74B11A),
                    ),
                    child: Text(
                      isEditMode
                          ? 'Hapus (${selectedProducts.length})'
                          : 'Checkout (${selectedProducts.length})',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
