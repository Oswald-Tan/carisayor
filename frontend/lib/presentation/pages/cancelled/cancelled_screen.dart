import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import this for date formatting
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/data/model/top_up_poin_model.dart';
import 'package:frontend/data/services/topup_service.dart';

class CancelledScreen extends StatefulWidget {
  static String routeName = "/cancelled";
  const CancelledScreen({super.key});

  @override
  CancelledScreenState createState() => CancelledScreenState();
}

class CancelledScreenState extends State<CancelledScreen> {
  final TopUpPoinService _topUpService = TopUpPoinService();
  late Future<List<TopUpPoin>> _fetchData;

  @override
  void initState() {
    super.initState();
    _fetchData = _topUpService.fetchTopUpPoin(context);
  }

  Future<void> _onRefresh() async {
    // Re-fetch the data when the user pulls down to refresh
    setState(() {
      _fetchData = _topUpService.fetchTopUpPoin(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F1F5),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 85),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            color: const Color(0xFF74B11A),
            backgroundColor: Colors.white,
            child: FutureBuilder<List<TopUpPoin>>(
              future: _fetchData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.poppins(
                          color: Colors.red, fontWeight: FontWeight.w400),
                    ),
                  );
                }

                final topUpData = snapshot.data
                        ?.where((item) => item.status == 'cancelled')
                        .toList() ??
                    [];

                return ListView.builder(
                  itemCount: topUpData.isEmpty ? 1 : topUpData.length,
                  itemBuilder: (context, index) {
                    if (topUpData.isEmpty) {
                      // Tampilan saat data kosong
                      return Center(
                        child: Column(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.circleXmark, // Ikon silang
                              size: 48.0,
                              color: Color(0xFFD8D8D8),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Tidak ada data.',
                              style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      );
                    }

                    final historyItem = topUpData[index];
                    // String imagePath = mapTitleToImage(historyItem['title']);
                    String imagePath = 'assets/images/top_up_history.png';
                    Color statusColor = historyItem.status == 'cancelled'
                        ? const Color(0xFFE83F3F)
                        : const Color(0xFF59C978);

                    // Initialize intl package for date formatting
                    initializeDateFormatting('id_ID');

                    // Format timestamp
                    String formattedDate = DateFormat.yMMMMd('id_ID')
                        .format(DateTime.parse(historyItem.date));
                    String formattedTime = DateFormat.Hm()
                        .format(DateTime.parse(historyItem.date));

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF0F1F5),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: SizedBox(
                                          width: 25,
                                          child: Image.asset(
                                            color: const Color(0xFFE83F3F),
                                            imagePath,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Top Up',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF1F2131),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      width: 16,
                                      'assets/images/poin_cs.png',
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      historyItem.points.toString(),
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF1F2131),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: const Divider(
                                color: Color(0xFFF0F1F5),
                                thickness: 1,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          formattedDate, // Display formatted date and time
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF828282),
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          formattedTime, // Display formatted date and time
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF828282),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 4,
                                          bottom: 4),
                                      decoration: BoxDecoration(
                                        color: statusColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Dibatalkan',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Function to map title to image
  String mapTitleToImage(String title) {
    if (title == 'Top Up') {
      return 'assets/images/top_up_history.png';
    } else if (title == 'Expense') {
      return 'assets/images/expense_history.png';
    }
    return 'assets/images/send.png';
  }
}
