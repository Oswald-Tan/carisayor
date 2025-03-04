import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/presentation/providers/user_provider.dart';
import 'package:frontend/data/model/pesanan_model.dart';
import 'package:frontend/core/api/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PesananService {
  final Dio _dio = Dio();

  Future<List<PesananModel>> getPesananByUser(
      BuildContext context, int userId) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;
      final userId = userProvider.userId;

      if (token == null || userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.get(
        '$baseUrl/pesanan-app/user/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return (response.data['data'] as List)
          .map((pesanan) => PesananModel.fromJson(pesanan))
          .toList();
    } on DioException catch (e) {
      debugPrint('Error: ${e.message}');
      throw Exception('Gagal mengambil pesanan: ${e.message}');
    }
  }

  Future<List<PesananModel>> getPesananByUserDelivered(
      BuildContext context, int userId) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;
      final userId = userProvider.userId;

      if (token == null || userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.get(
        '$baseUrl/pesanan-app/user-delivered/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return (response.data['data'] as List)
          .map((pesanan) => PesananModel.fromJson(pesanan))
          .toList();
    } on DioException catch (e) {
      debugPrint('Error: ${e.message}');
      throw Exception('Gagal mengambil pesanan: ${e.message}');
    }
  }

  Future<bool> bayarDenganCOD(
    context,
    int totalBayar,
    int ongkir,
    int totalBayarSemua,
    String invoiceNumber,
    List<Map<String, dynamic>> items, // Tambahkan parameter items
  ) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;
      final userId = userProvider.userId;

      if (token == null || userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio
          .post(
        '$baseUrl/pesanan-app/cod',
        data: {
          'userId': userId,
          'metodePembayaran': 'COD',
          'hargaRp': totalBayar,
          'ongkir': ongkir,
          'totalBayar': totalBayarSemua,
          'invoiceNumber': invoiceNumber,
          'items': items, // Kirim items ke backend
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      )
          // Di fungsi bayarDenganCOD
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw 'Connection timeout, please try again later.'; // Gunakan string konsisten
        },
      );

      if (response.statusCode == 201) {
        debugPrint('Pesanan berhasil: ${response.data}');
        return true;
      } else {
        debugPrint('Failed with status: ${response.statusCode}');
        final errorMessage = response.data['message'] ?? 'Terjadi kesalahan';
        throw Exception(errorMessage);
      }
    } catch (e) {
      String errorMessage = 'Terjadi kesalahan saat membuat pesanan.';
      if (e is DioException) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else if (e.toString().contains('User not authenticated')) {
        errorMessage = 'Harap login terlebih dahulu.';
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Gagal',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Gagal memproses pesanan: $errorMessage',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8EC61D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                    ),
                    child: Text(
                      'Tutup',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
      return false;
    }
  }

  Future<bool> bayarDenganCODCart(
    context,
    String id,
    // String nama,
    int hargaRp,
    int ongkir,
    int totalBayar,
    String invoiceNumber,
    List<Map<String, dynamic>> items,
  ) async {
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
          'userId': userId,
          'id': id,
          // 'nama': nama,
          'metodePembayaran': 'COD',
          'hargaRp': hargaRp,
          'ongkir': ongkir,
          'totalBayar': totalBayar,
          'status': 'pending',
          'invoiceNumber': invoiceNumber,
          'items': items,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Menambahkan token ke header
          },
        ),
      );

      if (response.statusCode == 201) {
        debugPrint('Pesanan berhasil: ${response.data}');
        return true;
        // Menangani keberhasilan
      } else {
        debugPrint('Failed with status: ${response.statusCode}');
        final errorMessage = response.data['message'] ?? 'Terjadi kesalahan';
        throw Exception(errorMessage);
      }
    } catch (e) {
      String errorMessage = 'Terjadi kesalahan saat membuat pesanan.';

      if (e is DioException) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else if (e.toString().contains('User not authenticated')) {
        errorMessage = 'Harap login terlebih dahulu.';
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Sudut membulat
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Judul dialog
                  Text(
                    'Gagal',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Konten dialog
                  Text(
                    'Gagal memproses pesanan: $errorMessage',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8EC61D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30,
                      ),
                    ),
                    child: Text(
                      'Tutup',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
      return false;
    }
  }

  Future<bool> bayarDenganPoin(
    context,
    int totalBayar,
    int ongkir,
    int totalBayarSemua,
    String invoiceNumber,
    List<Map<String, dynamic>> items,
  ) async {
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
          'metodePembayaran': 'Poin',
          'hargaPoin': totalBayar,
          'ongkir': ongkir,
          'totalBayar': totalBayarSemua,
          'status': 'pending',
          'invoiceNumber': invoiceNumber,
          'items': items,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Jika request berhasil, tampilkan dialog sukses
      if (response.statusCode == 201) {
        return true; // Indikator berhasil
      } else {
        final errorMessage = response.data['message'] ?? 'Terjadi kesalahan';
        throw Exception(errorMessage);
      }
    } catch (e) {
      String errorMessage = 'Terjadi kesalahan, coba lagi nanti.';

      if (e is DioException) {
        debugPrint('Dio error response: ${e.response?.data}');
        // Jika error berasal dari response server
        if (e.response != null && e.response!.data is Map) {
          errorMessage = e.response!.data['message'] ?? errorMessage;

          if (errorMessage.contains("Poin Anda hanya")) {
            // Menangani poin tidak cukup
            if (context.mounted) {
              Navigator.of(context, rootNavigator: true).pop(); // Tutup loading
              Fluttertoast.showToast(
                msg: errorMessage,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 14.0,
              );
            }
            return false; // Indikator gagal
          }
        }
      } else if (e.toString().contains('User not authenticated')) {
        errorMessage = 'Harap login terlebih dahulu.';
      }

      // Tampilkan Fluttertoast untuk error selain poin tidak cukup
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Tutup loading
        Fluttertoast.showToast(
          msg: 'Gagal memproses pesanan: $errorMessage',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      }

      return false; // Indikator gagal
    }
  }

  Future<bool> bayarDenganPoinCart(
    context,
    String id,
    int hargaPoin,
    int ongkir,
    int totalBayar,
    String invoiceNumber,
    List<Map<String, dynamic>> items,
  ) async {
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
          'id': id,
          'metodePembayaran': 'Poin',
          'hargaPoin': hargaPoin,
          'ongkir': ongkir,
          'totalBayar': totalBayar,
          'status': 'pending',
          'invoiceNumber': invoiceNumber,
          'items': items,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Jika request berhasil, tampilkan dialog sukses
      if (response.statusCode == 201) {
        return true; // Indikator berhasil
      } else {
        final errorMessage = response.data['message'] ?? 'Terjadi kesalahan';
        throw Exception(errorMessage);
      }
    } catch (e) {
      String errorMessage = 'Terjadi kesalahan, coba lagi nanti.';

      if (e is DioException) {
        debugPrint('Dio error response: ${e.response?.data}');
        // Jika error berasal dari response server
        if (e.response != null && e.response!.data is Map) {
          errorMessage = e.response!.data['message'] ?? errorMessage;

          if (errorMessage.contains("Poin Anda hanya")) {
            // Menangani poin tidak cukup
            if (context.mounted) {
              Navigator.of(context, rootNavigator: true).pop(); // Tutup loading
              Fluttertoast.showToast(
                msg: errorMessage,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 14.0,
              );
            }
            return false; // Indikator gagal
          }
        }
      } else if (e.toString().contains('User not authenticated')) {
        errorMessage = 'Harap login terlebih dahulu.';
      }

      // Tampilkan Fluttertoast untuk error selain poin tidak cukup
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Tutup loading
        Fluttertoast.showToast(
          msg: 'Gagal memproses pesanan: $errorMessage',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      }

      return false; // Indikator gagal
    }
  }
}
