import 'package:flutter/material.dart';
import 'package:frontend/screens/top_up/topup_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:frontend/services/poin_service.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/user_provider.dart';

class InvoicePage extends StatelessWidget {
  final int points;
  final int price;
  final DateTime date;
  final String bankName;
  final String noHp;

  const InvoicePage({
    super.key,
    required this.points,
    required this.price,
    required this.date,
    required this.bankName,
    required this.noHp,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("#,##0", "id_ID");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Invoice',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2131),
            fontSize: 16,
          ),
        ),
        centerTitle: true,
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
                  "Points: ",
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
                  "Price: ",
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
                  "Date: ",
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bank Name: ",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  bankName,
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
                  "Total: ",
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
            const SizedBox(height: 40),
            Text(
              "Hubungi Kami",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              thickness: 1,
              color: Color(0xFFD9D9D9),
            ),
            Text(
              "Hubungi kami segera setelah pembayaran dan kirimkan bukti pembayaran agar top up poin Anda dapat diverifikasi dan diproses dengan cepat.",
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Phone Number: ",
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
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                // Menampilkan dialog konfirmasi
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        'Konfirmasi Top Up',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2131),
                        ),
                      ),
                      content: Text(
                        'Apakah anda yakin ingin melakukan top up?',
                        style:
                            GoogleFonts.poppins(color: const Color(0xFF1F2131)),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Menutup dialog jika "No"
                          },
                          child: Text(
                            'No',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1F2131)),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              // Get the user provider for token and userId
                              final userProvider = Provider.of<UserProvider>(
                                  context,
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Color(0xFF74B11A),
                                      content: Text("Top-Up Successful!")),
                                );
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const TopUpPage()),
                                );
                              } else {
                                throw Exception("User not authenticated.");
                              }
                            } catch (e) {
                              // Handle errors
                              print('Error: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
                            }
                            Navigator.of(context)
                                .pop(); // Menutup dialog setelah konfirmasi
                          },
                          child: Text(
                            'Yes',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1F2131)),
                          ),
                        ),
                      ],
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
