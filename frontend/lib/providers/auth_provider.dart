import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Untuk penyimpanan token
import 'package:frontend/api/config.dart';
import 'package:frontend/providers/user_provider.dart'; // Pastikan UserProvider sudah di-import

class AuthProvider with ChangeNotifier {
  String? _token;

  // Cek apakah user sudah login berdasarkan token
  bool get isAuthenticated => _token != null;

  // Simpan token ke SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    notifyListeners();
  }

  // Fungsi logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); //ambil token dari penyimpanan

    if (token != null) {
      //kirim request logout ke backend
      final url = Uri.parse('$baseUrl/auth/logout');

      try {
        final res = await http.post(
          url,
          headers: {
            'Authorization':
                'Bearer $token', //kirim token pada header authorization
          },
        );

        if (res.statusCode == 200) {
          //berhasil logout, hapus token dari penyimpanan
          await prefs.remove('token');
          _token = null;
          notifyListeners(); //notifikasi perubahan untuk memperbarui UI
        } else {
          debugPrint('Logout failed: ${res.body}');
        }
      } catch (error) {
        debugPrint('Error: $error');
      }
    }
  }

  Future<String?> registerUser({
    required String username,
    required String password,
    required String email,
    required String roleName,
    required String phoneNumber,
    String? referralCode, // Tambahkan field opsional untuk referral code
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');

    try {
      // Buat body request
      final requestBody = {
        'username': username,
        'password': password,
        'email': email,
        'phone_number': phoneNumber,
        'role_name': roleName,
      };

      // Jika referralCode ada, tambahkan ke body request
      if (referralCode != null && referralCode.isNotEmpty) {
        requestBody['referralCode'] = referralCode;
      }

      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (res.statusCode == 201) {
        // Registrasi berhasil
        return null;
      } else {
        // Tangkap pesan error dari API
        final responseBody = jsonDecode(res.body);
        return responseBody['message'];
      }
    } catch (error) {
      debugPrint('Error: $error');
      return 'Internal server error. Please try again later.';
    }
  }

  // Login pengguna dan simpan token
  Future<bool> loginUser({
    required String email,
    required String password,
    required UserProvider userProvider,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final res = await http
          .post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      )
          .timeout(
        const Duration(seconds: 10), // Timeout 10 detik
        onTimeout: () {
          // Jika timeout terjadi, return custom response atau exception
          throw 'Connection timeout, please try again later.';
        },
      );
      ;

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final token = data['token'];
        debugPrint('Login successful, token: $token');

        // Simpan token ke SharedPreferences
        await _saveToken(token);

        // Panggil UserProvider untuk mengambil data pengguna setelah login berhasil
        await userProvider.getUserData(token);

        return true;
      } else {
        // Tangkap pesan kesalahan dari backend
        final errorData = jsonDecode(res.body);
        final errorMessage = errorData['message'] ?? 'Login failed';
        print('Failed to login: $errorMessage');
        throw errorMessage;
      }
    } catch (error) {
      // print('Error: $error');
      rethrow;
    }
  }

  // Muat token ketika aplikasi dimulai
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }
}
