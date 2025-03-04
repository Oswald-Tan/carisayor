import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/providers/user_provider.dart';
import 'package:frontend/presentation/providers/cart_provider.dart';
import 'package:frontend/core/api/config.dart';
import 'package:provider/provider.dart';
import 'package:frontend/data/model/cart_item.dart';

class CartService {
  final Dio _dio = Dio();

  Future<void> addToCart(
      BuildContext context, String userId, String productId, int berat) async {
    try {
      // Ambil ID pengguna dan token dari UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.post(
        '$baseUrl/cart-app',
        data: {'userId': userId, 'productId': productId, 'berat': berat},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Menambahkan token ke header
          },
        ),
      );

      // Periksa apakah status code berhasil (200 OK atau 201 Created)
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Pesanan berhasil: ${response.data}');

        // Perbarui cartItemCount dari server setelah menambahkan produk
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        int updatedCount =
            await getCartItemCount(context); // Ambil nilai terbaru dari server
        cartProvider
            .setCartItemCount(updatedCount); // Perbarui state di CartProvider
      } else {
        debugPrint('Failed with status: ${response.statusCode}');
        throw Exception('Failed to add to cart');
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to add to cart');
    }
  }

  Future<List<CartItem>> getCartItems(BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;
      final userId = userProvider.userId;

      if (token == null || userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.get(
        '$baseUrl/cart-app/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Tangani kondisi keranjang kosong
        if (response.data['cart'] == null ||
            (response.data['cart'] as List).isEmpty) {
          debugPrint('Keranjang kosong untuk user $userId');
          return []; // Mengembalikan array kosong
        }

        // Konversi data menjadi List<CartItem>
        List<CartItem> cartItems = (response.data['cart'] as List)
            .map((item) => CartItem.fromJson(item))
            .toList();
        return cartItems;
      } else {
        throw Exception(
            'Gagal memuat keranjang (status: ${response.statusCode})');
      }
    } catch (e, stackTrace) {
      // Log error untuk debug
      debugPrint('Error in getCartItems: $e');
      debugPrint('StackTrace: $stackTrace');

      // Tangani error selain autentikasi dengan array kosong
      if (e.toString().contains('User not authenticated')) {
        rethrow; // Lempar ulang error autentikasi
      }

      return []; // Mengembalikan array kosong jika error lain
    }
  }

  // Memperbarui jumlah berat di keranjang
  Future<void> updateCartItem(
      BuildContext context, String userId, String productId, int berat) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.post(
        '$baseUrl/cart-app/update-berat',
        data: {
          'userId': userId,
          'productId': productId,
          'berat': berat,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.data}');

      if (response.statusCode == 200) {
        debugPrint('Keranjang berhasil diperbarui');
      } else {
        throw Exception('Failed to update cart item on the server');
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to update cart item');
    }
  }

  Future<int> getCartItemCount(context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;
      final userId = userProvider.userId;

      if (token == null || userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.get(
        '$baseUrl/cart-app/item-count/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        int itemCount = response.data['itemCount'];
        return itemCount;
      } else {
        throw Exception(
            'Gagal memuat jumlah item keranjang (status: ${response.statusCode})');
      }
    } catch (e, stackTrace) {
      debugPrint('Error in getCartItemCount: $e');
      debugPrint('StackTrace: $stackTrace');
      throw Exception('Failed to get cart item count');
    }
  }

  // Hapus item di keranjang berdasarkan cartId
  Future<void> deleteCartItem(
      BuildContext context, String userId, String cartId) async {
    try {
      // Ambil token pengguna dari UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      if (token == null) {
        throw Exception('User not authenticated');
      }

      // Kirim request DELETE ke backend
      final response = await _dio.delete(
        '$baseUrl/cart-app/$cartId',
        data: {'userId': userId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('Cart item deleted successfully: ${response.data}');

        // Perbarui cartItemCount dari server setelah menambahkan produk
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        int updatedCount =
            await getCartItemCount(context); // Ambil nilai terbaru dari server
        cartProvider
            .setCartItemCount(updatedCount); // Perbarui state di CartProvider
      } else {
        throw Exception(
            'Failed to delete cart item (status: ${response.statusCode})');
      }
    } catch (e, stackTrace) {
      debugPrint('Error in deleteCartItem: $e');
      debugPrint('StackTrace: $stackTrace');
      throw Exception('Failed to delete cart item');
    }
  }
}
