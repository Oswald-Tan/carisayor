// import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/providers/user_provider.dart';
import 'package:frontend/core/api/config.dart';
import 'package:provider/provider.dart';
import 'package:frontend/data/model/top_up_poin_model.dart';

class TopUpPoinService {
  final Dio _dio = Dio();

  // Fungsi untuk melakukan top-up data ke server
  Future<void> postTopUpData(BuildContext context, int points, int price,
      DateTime date, String bankName) async {
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
        '$baseUrl/topup-app', // Gantilah dengan endpoint yang sesuai
        data: {
          'userId': userId, // Mengirim ID pengguna
          'points': points,
          'price': price,
          'date': date.toIso8601String(),
          'bankName': bankName,
          'status': 'pending',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Menambahkan token ke header
          },
        ),
      );

      if (response.statusCode == 201) {
        debugPrint('Top-Up berhasil: ${response.data}');
        // Menangani keberhasilan
      } else {
        debugPrint('Failed with status: ${response.statusCode}');
        throw Exception('Failed to top-up');
      }
    } catch (e) {
      throw Exception('Error during top-up: $e');
    }
  }

  // Fungsi untuk mengambil data top-up dari server
  Future<List<TopUpPoin>> fetchTopUpPoin(BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio
          .get(
        '$baseUrl/topup-app/user',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw 'Connection timeout, please try again later.';
        },
      );

      if (response.statusCode == 200) {
        if (response.data is Map &&
            response.data['message'] == "Belum ada data") {
          return []; // Mengembalikan list kosong, tidak melempar error
        } else if (response.data is List) {
          List<dynamic> data = response.data;
          return data.map((json) => TopUpPoin.fromJson(json)).toList();
        } else {
          return []; // Jika format tidak sesuai, anggap tidak ada data
        }
      } else if (response.statusCode == 404) {
        return []; // Jika API mengembalikan 404, kembalikan list kosong
      } else {
        throw Exception('Failed to fetch top-up data');
      }
    } catch (error) {
      debugPrint("Error fetching top-up data: $error");
      return []; // Pastikan selalu mengembalikan list kosong, bukan exception
    }
  }

  Future<void> cancelTopUp(String topUpId, BuildContext context) async {
    try {
      // Ambil token dari UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.post(
        '$baseUrl/topup-app/cancel/$topUpId',
        data: {
          'status': 'cancelled',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('Status updated successfully');
        // Handle success, misalnya tampilkan pesan atau update UI
      } else {
        debugPrint('Failed to update status');
        throw Exception('Failed to cancel top-up');
      }
    } catch (e) {
      debugPrint('Error during cancellation: $e');
    }
  }
}
