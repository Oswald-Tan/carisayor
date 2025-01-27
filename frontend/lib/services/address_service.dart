import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/model/address_model.dart';
import 'package:frontend/api/config.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/user_provider.dart';

class AddressService {
  final Dio _dio = Dio();

  // Fungsi untuk mendapatkan daftar alamat pengguna
  Future<List<Address>> getUserAddresses(
      BuildContext context, int? userId) async {
    // make userId nullable
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      // Pastikan token dan userId ada
      if (token == null || userId == null) {
        throw Exception('User not authenticated.');
      }

      final response = await _dio.get(
        '$baseUrl/addresses/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<Address> addresses = (response.data['data'] as List)
            .map((addressData) => Address.fromJson(addressData))
            .toList();
        return addresses;
      } else {
        throw Exception('Failed to load addresses');
      }
    } catch (error) {
      debugPrint("Error fetching user addresses: $error");
      throw Exception('Failed to load addresses');
    }
  }

  //dapatkan alamat berdasarkann Id
  Future<Address?> getAddressById(
      {required BuildContext context, required int addressId}) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.get(
        '$baseUrl/addresses/get-address-id/$addressId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final address = Address.fromJson(response.data['data']);
        return address;
      } else {
        String errorMessage = 'Failed to retrieve address';
        if (response.data != null && response.data['message'] != null) {
          errorMessage = response.data['message'];
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (error) {
      debugPrint("Error retrieving address: $error");
      if (error is DioException) {
        debugPrint("DioException Details:");
        debugPrint("Type: ${error.type}");
        debugPrint("Message: ${error.message}");
        debugPrint("Response: ${error.response?.data}");
        debugPrint("Status Code: ${error.response?.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error retrieving address")),
        );
      }
    }
    return null;
  }

  // Fungsi untuk mengedit alamat
  Future<Map<String, dynamic>> editAddress({
    required BuildContext context,
    required int id,
    required String recipientName,
    required String phoneNumber,
    required String addressLine1,
    required String city,
    required String state,
    required String postalCode,
    required bool isDefault,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;
      final userId = userProvider.userId;

      if (token == null || userId == null) {
        throw Exception('User not authenticated.');
      }

      final response = await _dio.put(
        '$baseUrl/addresses/$id',
        data: {
          'user_id': userId,
          'recipient_name': recipientName,
          'phone_number': phoneNumber,
          'address_line_1': addressLine1,
          'city': city,
          'state': state,
          'postal_code': postalCode,
          'isDefault': isDefault,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Address updated successfully!");
        return response.data; // Mengembalikan data dari server
      } else {
        debugPrint(
            "Failed to update address. Status Code: ${response.statusCode}");
        throw Exception('Failed to update address');
      }
    } catch (error) {
      debugPrint("Error updating address: $error");
      throw error; // Melempar kembali error ke pemanggil
    }
  }

  // Fungsi untuk mendapatkan alamat default pengguna
  Future<Address?> getDefaultAddress(BuildContext context, int? userId) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      debugPrint("Token: $token");
      debugPrint("User ID: $userId");

      // Periksa apakah token dan userId valid
      if (token == null || userId == null) {
        debugPrint("User not authenticated.");
        throw Exception('User not authenticated.');
      }

      // Kirim permintaan API untuk mendapatkan alamat default
      final response = await _dio.get(
        '$baseUrl/addresses/default/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Periksa status respons
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['defaultAddress'] != null) {
          // Konversi data JSON ke objek Address
          return Address.fromJson(data['defaultAddress']);
        } else {
          debugPrint("Default address not found for user $userId.");
          return null; // Alamat default tidak ditemukan
        }
      } else {
        debugPrint(
            "Failed to fetch default address. Status code: ${response.statusCode}");
        throw Exception('Failed to fetch default address.');
      }
    } catch (error) {
      // Tangani error
      debugPrint("Error while fetching default address: $error");
      return null; // Return null jika terjadi error
    }
  }

  // Fungsi untuk menambahkan alamat
  Future<void> addAddress({
    required BuildContext context,
    required int? userId,
    required String recipientName,
    required String phoneNumber,
    required String addressLine1,
    required String city,
    required String state,
    required String postalCode,
    required bool isDefault,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      // Pastikan token tidak null
      if (token == null) {
        throw Exception('User not authenticated');
      }

      // Validasi input
      if (recipientName.isEmpty ||
          phoneNumber.isEmpty ||
          addressLine1.isEmpty ||
          city.isEmpty ||
          state.isEmpty ||
          postalCode.isEmpty) {
        throw Exception('All fields are required');
      }

      // Kirim permintaan POST ke server
      final response = await _dio.post(
        '$baseUrl/addresses',
        data: {
          'user_id': userId,
          'recipient_name': recipientName,
          'phone_number': phoneNumber,
          'address_line_1': addressLine1,
          'city': city,
          'state': state,
          'postal_code': postalCode,
          'isDefault': isDefault,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Periksa status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Address added successfully!");
        // Inform user with a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alamat berhasil ditambahkan')),
        );
      } else {
        debugPrint(
            "Failed to add address. Status Code: ${response.statusCode}");
        // Check if the response contains error messages
        String errorMessage = 'Failed to add address';
        if (response.data != null && response.data['message'] != null) {
          errorMessage = response.data['message'];
        }
        // Show error message in Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (error) {
      debugPrint("Error adding address: $error");

      // Jika ada DioException, log detailnya
      if (error is DioException) {
        debugPrint("DioException Details:");
        debugPrint("Type: ${error.type}");
        debugPrint("Message: ${error.message}");
        debugPrint("Response: ${error.response?.data}");
        debugPrint("Status Code: ${error.response?.statusCode}");

        // Handle error response and display the error message
        String errorMessage = 'Error adding address';
        if (error.response != null && error.response?.data != null) {
          errorMessage = error.response?.data['message'] ?? errorMessage;
        }

        // Display the error message in the snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  // Fungsi untuk menghapus alamat
  Future<void> deleteAddress(BuildContext context, int id) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;
      final userId = userProvider.userId;

      // Pastikan user terautentikasi
      if (token == null || userId == null) {
        throw Exception('User not authenticated');
      }

      // Kirim permintaan delete ke backend dengan konfigurasi validateStatus
      final response = await _dio.delete(
        '$baseUrl/addresses/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) {
            // Agar status code 400 tidak dianggap sebagai error
            return status! < 500;
          },
        ),
      );

      // Periksa status code dari response
      if (response.statusCode == 200) {
        debugPrint('Address successfully deleted');
        // Update UI atau navigasi jika perlu
      } else if (response.statusCode == 400) {
        // Jika response status 400, ambil pesan error dari backend
        final message = response.data['message'];
        debugPrint("Error Message from Backend: $message");
        // Tampilkan pesan error dalam Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } else {
        debugPrint("Unexpected status code: ${response.statusCode}");
        throw Exception('Failed to delete address');
      }
    } catch (error) {
      // Tangani error yang terjadi, termasuk DioException
      if (error is DioException) {
        debugPrint("DioException: ${error.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error.message}')),
        );
      } else {
        debugPrint("Unknown error: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting address: $error')),
        );
      }
      throw Exception('Failed to delete address');
    }
  }

  // Fungsi untuk mendapatkan daftar kota yang didukung
  Future<List<String>> getCities(BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      // Pastikan token ada
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.get(
        '$baseUrl/supported-area-app/cities',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Mengonversi data ke dalam list String
        List<String> cities = List<String>.from(response.data['data']);
        return cities;
      } else {
        throw Exception('Failed to load cities');
      }
    } catch (error) {
      debugPrint("Error fetching cities: $error");
      throw Exception('Failed to load cities');
    }
  }

  Future<List<String>> getStates(BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      // Pastikan token ada
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.get(
        '$baseUrl/supported-area-app/states',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Mengonversi data ke dalam list String
        List<String> states = List<String>.from(response.data['data']);
        return states;
      } else {
        throw Exception('Failed to load states');
      }
    } catch (error) {
      debugPrint("Error fetching states: $error");
      throw Exception('Failed to load states');
    }
  }
}
