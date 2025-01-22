import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/api/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PesananService {
  final Dio _dio = Dio();

  Future<bool> bayarDenganCOD(BuildContext context, String nama, int hargaRp,
      int ongkir, int totalBayar, String invoiceNumber) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;
      final userId = userProvider.userId;

      if (token == null || userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.post(
        '$baseUrl/pesanan-app/cod',
        data: {
          'userId': userId,
          'nama': nama,
          'metodePembayaran': 'COD',
          'hargaRp': hargaRp,
          'ongkir': ongkir,
          'totalBayar': totalBayar,
          'status': 'pending',
          'invoiceNumber': invoiceNumber,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
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

  Future<bool> bayarDenganCODCart(BuildContext context, String nama,
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

  Future<bool> bayarDenganPoin(BuildContext context, String nama, int hargaPoin,
      int ongkir, int totalBayar, String invoiceNumber) async {
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
          'invoiceNumber': invoiceNumber,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201) {
        return true; // Indikator berhasil
      } else {
        final errorMessage = response.data['message'] ?? 'Terjadi kesalahan';
        throw Exception(errorMessage);
      }
    } catch (e) {
      String errorMessage = 'Terjadi kesalahan saat membuat pesanan.';

      if (e is DioError) {
        debugPrint('Dio error response: ${e.response?.data}');
        // Jika error berasal dari response server
        if (e.response != null && e.response!.data is Map) {
          errorMessage = e.response!.data['message'] ?? errorMessage;

          if (errorMessage.contains("Poin Anda hanya")) {
            // Menangani poin tidak cukup
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
                          errorMessage,
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
            return false; // Indikator gagal
          }
        }
      } else if (e.toString().contains('User not authenticated')) {
        errorMessage = 'Harap login terlebih dahulu.';
      }

      // Tampilkan dialog untuk error selain poin tidak cukup

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

      return false; // Indikator gagal
    }
  }

  Future<bool> bayarDenganPoinCart(BuildContext context, String nama,
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

      // Jika request berhasil, tampilkan dialog sukses
      if (response.statusCode == 201) {
        return true; // Indikator berhasil
      } else {
        final errorMessage = response.data['message'] ?? 'Terjadi kesalahan';
        throw Exception(errorMessage);
      }
    } catch (e) {
      String errorMessage = 'Terjadi kesalahan, coba lagi nanti.';

      if (e is DioError) {
        debugPrint('Dio error response: ${e.response?.data}');
        // Jika error berasal dari response server
        if (e.response != null && e.response!.data is Map) {
          errorMessage = e.response!.data['message'] ?? errorMessage;

          if (errorMessage.contains("Poin Anda hanya")) {
            // Menangani poin tidak cukup

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
                          errorMessage,
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
            return false; // Indikator gagal
          }
        }
      } else if (e.toString().contains('User not authenticated')) {
        errorMessage = 'Harap login terlebih dahulu.';
      }

      // Tampilkan dialog untuk error selain poin tidak cukup
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

      return false; // Indikator gagal
    }
  }
}
