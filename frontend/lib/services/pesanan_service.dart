import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/api/config.dart';
import 'package:provider/provider.dart';

class PesananService {
  final Dio _dio = Dio();

  Future<void> bayarDenganCOD(BuildContext context, String nama, int hargaRp,
      int ongkir, int totalBayar) async {
    try {
      // Ambil ID pengguna dan token dari UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;
      final userId = userProvider.userId; // Ambil user ID

      if (token == null || userId == null) {
        throw Exception('User not authenticated');
      }

      // Kirim data top-up melalui POST request
      final response = await _dio.post(
        '$baseUrl/pesanan-app/cod',
        data: {
          'userId': userId, // Mengirim ID pengguna
          'nama': nama,
          'metodePembayaran': 'COD',
          'hargaRp': hargaRp,
          'ongkir': ongkir,
          'totalBayar': totalBayar,
          'status': 'pending',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Menambahkan token ke header
          },
        ),
      );

      if (response.statusCode == 201) {
        print('Pesanan berhasil: ${response.data}');
        // Menangani keberhasilan
      } else {
        print('Failed with status: ${response.statusCode}');
        throw Exception('Failed to top-up');
      }
    } catch (e) {
      throw Exception('Error during top-up: $e');
    }
  }

  Future<void> bayarDenganCODCart(BuildContext context, String nama,
      int hargaRp, int ongkir, int totalBayar) async {
    try {
      // Ambil ID pengguna dan token dari UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;
      final userId = userProvider.userId; // Ambil user ID

      if (token == null || userId == null) {
        throw Exception('User not authenticated');
      }

      // Kirim data top-up melalui POST request
      final response = await _dio.post(
        '$baseUrl/pesanan-app/cod-cart',
        data: {
          'userId': userId, // Mengirim ID pengguna
          'nama': nama,
          'metodePembayaran': 'COD',
          'hargaRp': hargaRp,
          'ongkir': ongkir,
          'totalBayar': totalBayar,
          'status': 'pending',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Menambahkan token ke header
          },
        ),
      );

      if (response.statusCode == 201) {
        print('Pesanan berhasil: ${response.data}');
        // Menangani keberhasilan
      } else {
        print('Failed with status: ${response.statusCode}');
        throw Exception('Failed to top-up');
      }
    } catch (e) {
      throw Exception('Error during top-up: $e');
    }
  }

  Future<void> bayarDenganPoin(BuildContext context, String nama, int hargaPoin,
      int ongkir, int totalBayar) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;
      final userId = userProvider.userId;

      if (token == null || userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.post(
        '$baseUrl/pesanan-app/poin',
        data: {
          'userId': userId,
          'nama': nama,
          'metodePembayaran': 'Poin',
          'hargaPoin': hargaPoin,
          'ongkir': ongkir,
          'totalBayar': totalBayar,
          'status': 'pending',
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pesanan berhasil dibuat!')),
        );
      } else {
        final errorMessage = response.data['message'] ?? 'Terjadi kesalahan';
        throw Exception(errorMessage);
      }
    } catch (e) {
      String errorMessage = 'Terjadi kesalahan saat membuat pesanan.';

      if (e is DioError) {
        debugPrint('Dio error response: ${e.response?.data}');
        if (e.response != null && e.response!.data is Map) {
          errorMessage = e.response!.data['message'] ?? errorMessage;
        }
      } else if (e.toString().contains('User not authenticated')) {
        errorMessage = 'Harap login terlebih dahulu.';
      }

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Gagal memproses pesanan: $errorMessage'),
      // ));

      throw Exception(errorMessage);
    }
  }

  Future<void> bayarDenganPoinCart(BuildContext context, String nama,
      int hargaPoin, int ongkir, int totalBayar) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;
      final userId = userProvider.userId;

      if (token == null || userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.post(
        '$baseUrl/pesanan-app/poin-cart',
        data: {
          'userId': userId,
          'nama': nama,
          'metodePembayaran': 'Poin',
          'hargaPoin': hargaPoin,
          'ongkir': ongkir,
          'totalBayar': totalBayar,
          'status': 'pending',
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pesanan berhasil dibuat!')),
        );
      } else {
        final errorMessage = response.data['message'] ?? 'Terjadi kesalahan';
        throw Exception(
            errorMessage); // Pastikan error dilempar jika bukan status 201
      }
    } catch (e) {
      String errorMessage = 'Terjadi kesalahan saat membuat pesanan.';

      if (e is DioError) {
        debugPrint('Dio error response: ${e.response?.data}');
        // Jika error berasal dari response server
        if (e.response != null && e.response!.data is Map) {
          errorMessage = e.response!.data['message'] ?? errorMessage;
          if (errorMessage.contains("Poin Anda hanya")) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(errorMessage),
            ));
            return;
          }
        }
      } else if (e.toString().contains('User not authenticated')) {
        errorMessage = 'Harap login terlebih dahulu.';
      }

      // Tampilkan snackbar untuk error selain poin tidak cukup
      if (errorMessage != 'Poin Anda tidak cukup') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal memproses pesanan: $errorMessage'),
        ));
      }

      throw Exception(errorMessage);
    }
  }
}
