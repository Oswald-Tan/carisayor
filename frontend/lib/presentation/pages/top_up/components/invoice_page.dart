import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/presentation/pages/top_up/topup_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:frontend/data/services/poin_service.dart';
import 'package:provider/provider.dart';
import 'package:frontend/presentation/providers/user_provider.dart';

class InvoicePage extends StatelessWidget {
  final int points;
  final int price;
  final DateTime date;
  final String bankName;
  final String noHp;
  final String email;

  const InvoicePage({
    super.key,
    required this.points,
    required this.price,
    required this.date,
    required this.bankName,
    required this.noHp,
    required this.email,
  });

  @override
  Widget build(context) {
    final numberFormat = NumberFormat("#,##0", "id_ID");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Detail Top Up',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2131),
            fontSize: 16,
          ),
        ),
      ),
      // backgroundColor: const Color(0xFFF0F1F5),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Details",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Points",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/poin_cs.png',
                      width: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$points',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Price",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "Rp. ${numberFormat.format(price)}",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  DateFormat('d MMMM, yyyy - hh:mm a').format(date),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Bank Name",
            //       style: GoogleFonts.poppins(
            //         fontSize: 16,
            //         color: Colors.grey,
            //       ),
            //     ),
            //     Text(
            //       bankName,
            //       style: GoogleFonts.poppins(
            //         fontSize: 16,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "Rp. ${numberFormat.format(price)}",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(color: Color(0xFFE2E3E6), thickness: 1),
            const SizedBox(height: 10),
            Text(
              "Hubungi Kami",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0x23FFC875),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color.fromARGB(255, 250, 183, 84),
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            "Hubungi kami segera setelah pembayaran dan kirimkan bukti pembayaran agar top up poin Anda dapat diverifikasi dan diproses dengan cepat.",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: const Color(0xFFFF9A01),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "WhatsApp",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  noHp,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Email",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  email,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                // Menampilkan dialog konfirmasi
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Sudut membulat
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
                              'Konfirmasi Top Up',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Konten dialog
                            Text(
                              'Yakin ingin melakukan top up?',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),

                            // Tombol Batal
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Tutup dialog
                              },
                              child: Text(
                                'Tidak',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Tombol Logout
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  // Get the user provider for token and userId
                                  final userProvider =
                                      Provider.of<UserProvider>(context,
                                          listen: false);
                                  final token = userProvider.token;
                                  final userId = userProvider.userId;

                                  if (token != null && userId != null) {
                                    await PoinService().postTopUpData(
                                      context,
                                      points,
                                      price,
                                      date,
                                      bankName,
                                    );
                                    // Optionally, show a success message
                                    Fluttertoast.showToast(
                                      msg: "Top-Up Successful!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.TOP,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 14.0,
                                    );
                                    Navigator.of(context).pop();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TopUpPage()),
                                    );
                                  } else {
                                    throw Exception("User not authenticated.");
                                  }
                                } catch (e) {
                                  // Handle errors
                                  debugPrint('Error: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Error: $e")),
                                  );
                                }
                                Navigator.of(context)
                                    .pop(); // Menutup dialog setelah konfirmasi
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
                                'Yes',
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
              },
              child: Text(
                'Top Up',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
