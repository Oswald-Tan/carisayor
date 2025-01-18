import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/model/top_up_poin_model.dart';
import 'package:frontend/services/topup_service.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  _RiwayatScreenState createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final TopUpPoinService _topUpService = TopUpPoinService();
  late Future<List<TopUpPoin>> _fetchData;

  @override
  void initState() {
    super.initState();
    _fetchData = _topUpService.fetchTopUpPoin(context);
  }

  // Fungsi untuk memuat ulang data saat di-refresh
  Future<void> _refreshData() async {
    setState(() {
      _fetchData = _topUpService.fetchTopUpPoin(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F1F5),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<TopUpPoin>>(
          future: _fetchData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Belum ada transaksi.',
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
              );
            }

            List<TopUpPoin> transactions = snapshot.data!;

            // Menyaring transaksi dengan status "approved"
            List<TopUpPoin> approvedTransactions = transactions
                .where((transaction) => transaction.status == 'approved')
                .take(3)
                .toList();
            return Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'History',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: const Color(0xFF1F2131),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigasi ke halaman Activity (bisa disesuaikan)
                        },
                        child: Text(
                          'See All',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: const Color(0xFF828282),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Menampilkan transaksi yang diambil dari fetchTopUpPoin
                Column(
                  children: approvedTransactions.map((transaction) {
                    DateTime transactionDateTime =
                        DateTime.parse(transaction.date);
                    String formattedDate = _formatDate(transactionDateTime);
                    String formattedTime = _formatTime(transactionDateTime);
                    String transactionAmount = transaction.points.toString();

                    return History(
                      transactionTitle: 'Top Up',
                      transactionDate: '$formattedDate - $formattedTime',
                      transactionAmount: transactionAmount,
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Format tanggal tanpa menggunakan intl
  String _formatDate(DateTime date) {
    List<String> months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    String day = date.day.toString().padLeft(2, '0');
    String month = months[date.month - 1];
    String year = date.year.toString();
    return '$day $month $year';
  }

  // Format waktu tanpa menggunakan intl
  String _formatTime(DateTime date) {
    String hour = date.hour.toString().padLeft(2, '0');
    String minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class History extends StatelessWidget {
  final String transactionTitle;
  final String transactionDate;
  final String transactionAmount;

  const History({
    super.key,
    required this.transactionTitle,
    required this.transactionDate,
    required this.transactionAmount,
  });

  @override
  Widget build(BuildContext context) {
    String iconPath = getTransactionIcon(transactionTitle.toLowerCase());

    return Container(
      height: 70,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  iconPath,
                  width: 30,
                  height: 30,
                  color: const Color(0XFF74B11A),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Top Up', // Menggunakan nilai dari field title
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: const Color(0xFF1F2131),
                    ),
                  ),
                  Text(
                    transactionDate,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/poin_cs.png',
                  width: 18,
                ),
                const SizedBox(width: 5),
                Text(
                  transactionAmount,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: const Color(0xFF1F2131),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getTransactionIcon(String transactionType) {
    if (transactionType == 'top up') {
      return 'assets/images/top_up_history.png';
    } else if (transactionType == 'expense') {
      return 'assets/images/send.png'; // Ganti dengan path ikon untuk expense
    } else {
      return 'assets/images/expense_history.png'; // Ganti dengan path ikon default
    }
  }
}
