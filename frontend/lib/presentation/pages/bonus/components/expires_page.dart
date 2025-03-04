import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/data/model/afiliasi_bonus_model.dart';
import 'package:frontend/data/services/afiliasi_bonus_service.dart';
import 'package:intl/intl.dart';

final currencyFormat =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

String formatRupiah(int value) {
  return currencyFormat.format(value).replaceAll('Rp', 'Rp. ');
}

String formatNumber(int value) {
  final format = NumberFormat('#,##0', 'id_ID');
  return format.format(value);
}

class ExpiresPage extends StatefulWidget {
  const ExpiresPage({super.key});

  @override
  State<ExpiresPage> createState() => _ExpiresPageState();
}

class _ExpiresPageState extends State<ExpiresPage>
    with SingleTickerProviderStateMixin {
  final AfiliasiBonusService _afiliasiBonusService = AfiliasiBonusService();

  late Future<List<AfiliasiBonus>> _expiredBonuses;

  @override
  void initState() {
    super.initState();
    _expiredBonuses = _afiliasiBonusService.getExpiredBonuses(context);
  }

  Future<void> _onRefresh() async {
    setState(() {
      _expiredBonuses = _afiliasiBonusService.getExpiredBonuses(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Expires',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: const Color(0xFF74B11A),
        backgroundColor: Colors.white,
        child: FutureBuilder<List<AfiliasiBonus>>(
          future: _expiredBonuses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Tidak ada bonus expired.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            final bonuses = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(20),
              children: bonuses.map((bonus) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFF1F1F1)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bonus Anda',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${formatRupiah(bonus.bonusAmount)}\n'
                              'Expiry: ${DateFormat.yMMMEd().format(DateTime.parse(bonus.expiryDate))}',
                              style: GoogleFonts.poppins(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: const Color(0xFFF1F1F1),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Expired',
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
