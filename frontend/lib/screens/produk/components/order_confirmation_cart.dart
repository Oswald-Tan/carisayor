import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/screens/init_screen.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderConfirmationCartPage extends StatelessWidget {
  final List<String> namaProduk;
  final List<String> jumlah;
  final List<String> hargaProduk;
  final String satuan;
  final String ongkir;
  final String totalHarga;
  final String totalBayar;
  final String invoiceNumber;

  const OrderConfirmationCartPage({
    required this.namaProduk,
    required this.jumlah,
    required this.hargaProduk,
    required this.satuan,
    required this.ongkir,
    required this.totalHarga,
    required this.totalBayar,
    required this.invoiceNumber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isRupiahFormat(String text) {
      return text.contains('Rp');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              SvgPicture.asset(
                'assets/images/success.svg',
                width: 140,
                height: 140,
              ),
              const SizedBox(height: 20),
              Text(
                "Order Successfully!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Text(
                    "Menjelaskan waktu pengiriman produk.",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFe9e8e8)),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Invoice",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "No Invoice",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            invoiceNumber,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Nama",
                            style: GoogleFonts.poppins(),
                          ),
                          Consumer<UserProvider>(
                            builder: (context, userProvider, child) {
                              final username = userProvider.username ?? 'User';
                              return Text(
                                username,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Date",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            DateFormat(
                              'd MMMM, yyyy - hh:mm a',
                            ).format(DateTime.now()),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(
                        color: Color(0xFFe9e8e8),
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...namaProduk.asMap().entries.map((entry) {
                              int index = entry.key;
                              String productName = entry.value;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // Untuk rata kiri.
                                  children: [
                                    // Baris ProductName dan Jumlah
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            productName,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        isRupiahFormat('${hargaProduk[index]}')
                                            ? Text(
                                                '${hargaProduk[index]}',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            : Row(
                                                children: [
                                                  Image.asset(
                                                    width: 14,
                                                    'assets/images/poin_cs.png',
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${hargaProduk[index]}',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )
                                                ],
                                              ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    // Harga Produk
                                    Text(
                                      '${jumlah[index]} $satuan',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            const SizedBox(height: 4),
                            // Jumlah dan Harga
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Total Harga Produk',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                isRupiahFormat(totalHarga)
                                    ? Text(
                                        totalHarga,
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      )
                                    : Row(
                                        children: [
                                          Image.asset(
                                            width: 14,
                                            'assets/images/poin_cs.png',
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            totalHarga,
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFe9e8e8)),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Ongkos Kirim",
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          isRupiahFormat(ongkir)
                              ? Text(
                                  ongkir,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                  ),
                                )
                              : Row(
                                  children: [
                                    Image.asset(
                                      width: 14,
                                      'assets/images/poin_cs.png',
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      ongkir,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                        ],
                      ),
                      const Divider(
                        color: Color(0xFFe9e8e8),
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFF589400),
                            ),
                          ),
                          isRupiahFormat(totalBayar)
                              ? Text(
                                  totalBayar,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: const Color(0xFF589400),
                                  ),
                                )
                              : Row(
                                  children: [
                                    Image.asset(
                                      width: 16,
                                      'assets/images/poin_cs.png',
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      totalBayar,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: const Color(0xFF589400),
                                      ),
                                    )
                                  ],
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const InitScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF589400),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Back to home',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
