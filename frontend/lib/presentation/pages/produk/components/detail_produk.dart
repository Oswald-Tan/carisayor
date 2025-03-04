import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/produk/components/cart.dart';
import 'package:frontend/presentation/providers/cart_provider.dart';
import 'package:frontend/presentation/providers/user_provider.dart';
import 'package:frontend/presentation/pages/produk/components/buy_now_modal.dart';
import 'package:frontend/data/services/cart_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

final currencyFormat =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

String formatRupiah(int value) {
  return currencyFormat.format(value).replaceAll('Rp', 'Rp. ');
}

class DetailProduk extends StatefulWidget {
  final String? id;
  final String nama;
  final int hargaPoin;
  final String imagePath;
  final int hargaRp;
  final int berat;
  final String satuan;
  final String deskripsi;

  const DetailProduk({
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
  State<DetailProduk> createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk>
    with SingleTickerProviderStateMixin {
  final GlobalKey _cartKey = GlobalKey();
  final GlobalKey _addToCartKey = GlobalKey();
  late AnimationController _animationController;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Fungsi untuk memulai animasi

  void _startAnimation() {
    final RenderBox addToCartRenderBox =
        _addToCartKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox cartRenderBox =
        _cartKey.currentContext!.findRenderObject() as RenderBox;

    final Offset startPosition = addToCartRenderBox.localToGlobal(Offset.zero);
    final Offset endPosition = cartRenderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final progress =
              Curves.easeInOut.transform(_animationController.value);
          final currentPosition = Offset(
            startPosition.dx + (endPosition.dx - startPosition.dx) * progress,
            startPosition.dy + (endPosition.dy - startPosition.dy) * progress,
          );

          return Positioned(
            left: currentPosition.dx,
            top: currentPosition.dy,
            child: Opacity(
              opacity: 1 - progress,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    image: DecorationImage(
                      image: widget.imagePath.startsWith('http')
                          ? NetworkImage(widget.imagePath)
                          : AssetImage(widget.imagePath) as ImageProvider,
                      fit: BoxFit.cover,
                      onError: (error, stackTrace) {
                        return;
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  // Update fungsi addToCart
  Future<void> addToCart(BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;
      final userId = userProvider.userId;

      if (token != null && userId != null && widget.id != null) {
        await CartService().addToCart(
            context, userId.toString(), widget.id.toString(), widget.berat);

        // Reset animation controller
        _animationController.reset();

        // Jalankan animasi
        if (_addToCartKey.currentContext != null &&
            _cartKey.currentContext != null) {
          _startAnimation();
        }

        // Optional: Show toast message
        // Fluttertoast.showToast(
        //   msg: "Berhasil menambahkan ke keranjang!",
        //   gravity: ToastGravity.TOP,
        // );
      } else {
        throw Exception("User tidak terautentikasi atau ID produk kosong.");
      }
    } catch (e) {
      debugPrint('Error: $e');
      Fluttertoast.showToast(
        msg: "Error: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Detail Produk',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2131),
            fontSize: 16,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return Stack(
                  key: _cartKey,
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartScreen()),
                        );
                      },
                    ),
                    if (cartProvider.cartItemCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Text(
                            '${cartProvider.cartItemCount}',
                            style: GoogleFonts.poppins(
                              fontSize: 8,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Product Name Section
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F1F5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: widget.imagePath.startsWith('http')
                        ? Image.network(
                            widget.imagePath,
                            width: 200,
                            height: 200,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/placeholder.png',
                                width: 200,
                                height: 200,
                              );
                            },
                          )
                        : Image.asset(
                            widget.imagePath,
                            width: 200,
                            height: 200,
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.nama,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          color: const Color(0xFF1F2131),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/poin_cs.png',
                            width: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${widget.hargaPoin}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: const Color(0xFF1F2131),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatRupiah(widget.hargaRp),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${widget.berat} ${widget.satuan == "Kilogram" ? "Kg" : widget.satuan == "Gram" ? "gram" : widget.satuan}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: const Color(0xFF1F2131),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Deskripsi Produk Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deskripsi Produk',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: const Color(0xFF1F2131),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.deskripsi,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Spacer to push buttons to bottom
          const Spacer(),

          // Add to Cart and Buy Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Add to Cart Button with Icon
                Expanded(
                  key: _addToCartKey,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F2131),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        // side: const BorderSide(
                        //   color: Color(0xFF1F2131),
                        //   width: 2,
                        // ),
                      ),
                    ),
                    onPressed: () {
                      addToCart(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Add to Cart',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Buy Now Button with Icon
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF589400),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => BuyNowModal(
                          id: widget.id,
                          nama: widget.nama,
                          hargaPoin: widget.hargaPoin,
                          hargaRp: widget.hargaRp,
                          imagePath: widget.imagePath,
                          berat: widget.berat,
                          satuan: widget.satuan,
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_bag,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Buy Now',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
