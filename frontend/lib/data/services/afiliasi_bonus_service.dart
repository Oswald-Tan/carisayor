import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/model/afiliasi_bonus_model.dart';
import 'package:frontend/presentation/providers/user_provider.dart';
import 'package:frontend/core/api/config.dart';
import 'package:provider/provider.dart';

class AfiliasiBonusService {
  final Dio _dio = Dio();

  // Fungsi untuk mengambil bonus yang pending
  Future<List<AfiliasiBonus>> getPendingBonuses(BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;
      final userId = userProvider.userId;

      if (token == null || userId == null) {
        throw Exception('User not authenticated.');
      }

      final response = await _dio.get(
        '$baseUrl/afiliasi-bonus-app/pending/$userId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['pendingBonus'];
        // Kembalikan data kosong jika tidak ada bonus pending
        return data.isEmpty
            ? []
            : data.map((json) => AfiliasiBonus.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch pending bonuses.');
      }
    } catch (e) {
      debugPrint('Error fetching pending bonuses: $e');
      // Tangani error yang terjadi, jangan melempar error untuk kasus data kosong
      return []; // Kembalikan list kosong
    }
  }

  Future<List<AfiliasiBonus>> getExpiredBonuses(BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;
      final userId = userProvider.userId;

      if (token == null || userId == null) {
        throw Exception('User not authenticated.');
      }

      final response = await _dio.get(
        '$baseUrl/afiliasi-bonus-app/expired/$userId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['expiredBonus'];
        // Kembalikan data kosong jika tidak ada bonus expired
        return data.isEmpty
            ? []
            : data.map((json) => AfiliasiBonus.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch expired bonuses.');
      }
    } catch (e) {
      debugPrint('Error fetching expired bonuses: $e');
      // Tangani error yang terjadi, jangan melempar error untuk kasus data kosong
      return []; // Kembalikan list kosong
    }
  }

  // Fungsi untuk klaim bonus
  Future<void> claimBonus(BuildContext context, int bonusId) async {
    try {
      // Ambil token dari UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      // Validasi token
      if (token == null) {
        throw Exception('User not authenticated.');
      }

      // Request ke API untuk klaim bonus
      final response = await _dio.post(
        '$baseUrl/afiliasi-bonus-app/claim',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) {
            // Mengijinkan status kode 400 untuk tetap diterima
            return status! < 500;
          },
        ),
        data: json.encode({'bonusId': bonusId}),
      );

      // Cek status response
      if (response.statusCode == 200) {
        debugPrint('Bonus claimed successfully.');
      } else {
        final message = response.data['message'] ?? 'Failed to claim bonus.';
        throw Exception(message);
      }
    } catch (e) {
      debugPrint('Error claiming bonus: $e');
      rethrow;
    }
  }
}
