import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/api/config.dart';

class UserProvider with ChangeNotifier {
  String? _token;
  String? _username;
  String? _email;
  String? _role;
  int? _userId;
  int? _points;
  List<Map<String, dynamic>> _referrals = [];

  //tambah variable untuk menyimpan detail user
  String? _fullname;
  String? _phoneNumber;
  String? _photoProfile;

  // Getter untuk data detail user
  String? get fullname => _fullname;
  String? get phoneNumber => _phoneNumber;
  String? get photoProfile => _photoProfile;

  String? get token => _token;
  String? get username => _username;
  String? get email => _email;
  String? get role => _role;
  int? get userId => _userId;
  int? get points => _points;
  List<Map<String, dynamic>> get referrals => _referrals;

  bool get isAuthenticated => _token != null;

  Future<void> getUserData(String token) async {
    const url = '$baseUrl/auth/user';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        _userId = userData['id'];
        _username = userData['username'];
        _email = userData['email'];
        _role = userData['role'];
        _points = userData['points'];
        _referrals =
            List<Map<String, dynamic>>.from(userData['referrals'] ?? []);
        // Menambahkan data detail user
        _fullname = userData['userDetails']?['fullname'] ?? 'Tidak tersedia';
        _phoneNumber =
            userData['userDetails']?['phone_number'] ?? 'Tidak tersedia';
        _photoProfile = userData['userDetails']?['photo_profile'];

        _token = token;

        notifyListeners();
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error fetching user data: $error');
      rethrow;
    }
  }
}
