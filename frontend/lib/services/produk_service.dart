import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/api/config.dart';
import 'package:frontend/model/produk_model.dart';
import 'package:provider/provider.dart';

class ProdukService {
  final Dio _dio = Dio();

  Future<List<Produk>> fetchProduk(BuildContext context) async {
    try {
      // Ambil token dari UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      if (token == null) {
        throw Exception('User not authenticated');
      }

      // Kirim request dengan token di header Authorization
      final response = await _dio
          .get(
        '$baseUrl/products-app',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Menambahkan token ke header
          },
        ),
      )
          .timeout(
        const Duration(seconds: 10), // Timeout 10 detik
        onTimeout: () {
          // Jika timeout terjadi, return custom response atau exception
          throw 'Connection timeout, please try again later.';
        },
      );
      ;

      // print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Mengambil data poin dari response
        List<Produk> produkList = (response.data as List)
            .map((json) => Produk.fromJson(json))
            .toList();

        return produkList;
      } else {
        throw Exception('Failed to load produk');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}
