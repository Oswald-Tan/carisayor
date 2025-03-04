import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/data/model/top_up_poin_model.dart';
import 'package:frontend/data/services/topup_service.dart';

class PendingScreen extends StatefulWidget {
  static String routeName = "/history";
  const PendingScreen({super.key});

  @override
  PendingScreenState createState() => PendingScreenState();
}

class PendingScreenState extends State<PendingScreen> {
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

                final topUpData = snapshot.data!
                    .where((item) => item.status == 'pending')
                    .toList();

                return ListView.builder(
                  itemCount: topUpData.isEmpty ? 1 : topUpData.length,
                  itemBuilder: (context, index) {
                    if (topUpData.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.clock,
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
                    String imagePath = 'assets/images/top_up_history.png';
                    Color statusColor = historyItem.status == 'pending'
                        ? const Color(0xFFE58F0E)
                        : const Color(0xFF3D9F58);

                    initializeDateFormatting('id_ID');
                    String formattedDate = DateFormat.yMMMMd('id_ID')
                        .format(DateTime.parse(historyItem.date));
                    String formattedTime = DateFormat.Hm()
                        .format(DateTime.parse(historyItem.date));

                    return Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 15, right: 15, bottom: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF0F1F5),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: SizedBox(
                                                  width: 25,
                                                  child: Image.asset(
                                                    color:
                                                        const Color(0XFFF9B32D),
                                                    imagePath,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              'Top Up',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/poin_cs.png',
                                              width: 16,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              historyItem.points.toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Color(0xFFF0F1F5),
                                      thickness: 1,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              formattedDate,
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              formattedTime,
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: statusColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            historyItem.status,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 2,
                              right: 0,
                              child: Center(
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color(0xFFE83F3F),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    onPressed: () {
                                      _showConfirmationDialog(
                                        context,
                                        historyItem.id.toString(),
                                        _topUpService,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
}

// String mapTitleToImage(String title) {
//   if (title == 'Top Up') {
//     return 'assets/images/top_up_history.png';
//   } else if (title == 'Expense') {
//     return 'assets/images/expense_history.png';
//   }
//   return 'assets/images/send.png';
// }

void _showConfirmationDialog(
    BuildContext context, String topUpId, TopUpPoinService topUpService) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          'Konfirmasi',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Apakah Anda yakin ingin membatalkan proses Top Up CS Poin?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Tunggu saja',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, color: const Color(0xFF1F2131)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // Panggil service cancelTopUp menggunakan parameter topUpService
              await topUpService.cancelTopUp(topUpId, context);
            },
            child: Text(
              'Ya',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, color: const Color(0xFF1F2131)),
            ),
          ),
        ],
      );
    },
  );
}
