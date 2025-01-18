import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/api/config.dart';

class UserProvider with ChangeNotifier {
  String? _token;
  String? _username;
  String? _email;
  String? _role;
  String? _fullName;
  String? _phoneNumber;
  int? _userId;
  int? _points;
  List<Map<String, dynamic>> _referrals = [];

  String? get token => _token;
  String? get username => _username;
  String? get email => _email;
  String? get role => _role;
  String? get fullName => _fullName;
  String? get phoneNumber => _phoneNumber;
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
        _fullName = userData['full_name'];
        _phoneNumber = userData['phone_number'];
        _points = userData['points'];
        _referrals =
            List<Map<String, dynamic>>.from(userData['referrals'] ?? []);
        _token = token;

        notifyListeners();
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching user data: $error');
      rethrow;
    }
  }
}
