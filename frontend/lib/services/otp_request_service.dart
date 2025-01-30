import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/model/otp_request_model.dart';
import 'package:frontend/api/config.dart';

class OTPRequestService {
  final Dio _dio = Dio();

  Future<OtpResponse?> requestOtp(BuildContext context, String email) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/request-reset-otp',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        return OtpResponse.fromJson(response.data);
      } else {
        throw Exception('Gagal request OTP. Coba lagi nanti.');
      }
    } on DioException catch (e) {
      debugPrint('DioError: ${e.response?.data}');
      return OtpResponse(
          message:
              'Gagal request OTP: ${e.response?.data['message'] ?? 'Coba lagi.'}');
    } catch (e) {
      debugPrint('Error: $e');
      return OtpResponse(message: 'Terjadi kesalahan. Coba lagi.');
    }
  }

  // Verify OTP
  Future<OtpResponse?> verifyOtp(
      BuildContext context, String email, String otp) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/verify-reset-otp',
        data: {'email': email, 'otp': otp},
      );

      if (response.statusCode == 200) {
        return OtpResponse.fromJson(response.data);
      } else {
        throw Exception('Gagal memverifikasi OTP. Coba lagi nanti.');
      }
    } on DioException catch (e) {
      debugPrint('DioError: ${e.response?.data}');
      return OtpResponse(
          message:
              'Gagal verifikasi OTP: ${e.response?.data['message'] ?? 'Coba lagi.'}');
    } catch (e) {
      debugPrint('Error: $e');
      return OtpResponse(message: 'Terjadi kesalahan. Coba lagi.');
    }
  }

  // Reset Password
  Future<OtpResponse?> resetPassword(BuildContext context, String email,
      String newPassword, String confirmPassword) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/reset-password',
        data: {
          'email': email,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword
        },
      );

      if (response.statusCode == 200) {
        return OtpResponse.fromJson(response.data);
      } else {
        throw Exception('Gagal mereset password. Coba lagi nanti.');
      }
    } on DioException catch (e) {
      debugPrint('DioError: ${e.response?.data}');
      return OtpResponse(
          message:
              'Gagal reset password: ${e.response?.data['message'] ?? 'Coba lagi.'}');
    } catch (e) {
      debugPrint('Error: $e');
      return OtpResponse(message: 'Terjadi kesalahan. Coba lagi.');
    }
  }

  Future<String?> getResetOtpExpiry(BuildContext context, String email) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/get-reset-otp-expiry',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        // Ambil expiryTime dari response dan kembalikan sebagai string
        return response.data['expiryTime'];
      } else {
        throw Exception(
            'Gagal mendapatkan waktu kadaluarsa OTP. Coba lagi nanti.');
      }
    } on DioException catch (e) {
      debugPrint('DioError: ${e.response?.data}');
      return 'Gagal mendapatkan waktu kadaluarsa OTP: ${e.response?.data['message'] ?? 'Coba lagi.'}';
    } catch (e) {
      debugPrint('Error: $e');
      return 'Terjadi kesalahan. Coba lagi.';
    }
  }
}
