import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/bonus/components/referrals_page.dart';
import 'package:frontend/model/total_bonus_model.dart';
import 'package:frontend/model/afiliasi_bonus_model.dart';
import 'package:frontend/services/total_bonus_service.dart';
import 'package:frontend/services/afiliasi_bonus_service.dart';
import 'package:google_fonts/google_fonts.dart';
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

class BonusScreen extends StatefulWidget {
  const BonusScreen({super.key});

  @override
  _BonusScreenState createState() => _BonusScreenState();
}

class _BonusScreenState extends State<BonusScreen>
    with SingleTickerProviderStateMixin {
  final TotalBonusService _totalBonusService = TotalBonusService();
  final AfiliasiBonusService _afiliasiBonusService = AfiliasiBonusService();

  late Future<TotalBonus> _totalBonus;
  late Future<List<AfiliasiBonus>> _pendingBonuses;
  late Future<List<AfiliasiBonus>> _expiredBonuses;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _totalBonus = _totalBonusService.getTotalBonus(context);
    _pendingBonuses = _afiliasiBonusService.getPendingBonuses(context);
    _expiredBonuses = _afiliasiBonusService.getExpiredBonuses(context);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _claimBonus(int bonusId) async {
    try {
      await _afiliasiBonusService.claimBonus(context, bonusId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bonus berhasil diklaim!')),
      );
      setState(() {
        _pendingBonuses = _afiliasiBonusService.getPendingBonuses(context);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal klaim bonus: $e')),
      );
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _totalBonus = _totalBonusService.getTotalBonus(context);
      _pendingBonuses = _afiliasiBonusService.getPendingBonuses(context);
      _expiredBonuses = _afiliasiBonusService.getExpiredBonuses(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Bonus',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2131),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const FaIcon(
              size: 16,
              FontAwesomeIcons.userGroup,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ReferralPage()));
            },
          )
        ],
      ),
      backgroundColor: const Color(0xFFF0F1F5),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: const Color(0xFF74B11A),
        child: ListView(
          children: [
            FutureBuilder<TotalBonus>(
              future: _totalBonus,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  );
                }

                int totalBonus = snapshot.data?.totalBonus ?? 0;

                return Column(
                  children: [
                    Center(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF9F9F9),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Rp. ',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    formatNumber(totalBonus),
                                    style: GoogleFonts.poppins(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1F2131),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'bonus kamu',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Tambahkan TabBar dan TabBarView di sini
                    Column(
                      children: [
                        Container(
                          color: Colors.white,
                          child: TabBar(
                            controller: _tabController,
                            splashFactory: NoSplash.splashFactory,
                            indicatorColor: const Color(0xFF74B11A),
                            labelColor: const Color(0xFF74B11A),
                            unselectedLabelColor: Colors.grey,
                            dividerColor: Colors.transparent,
                            labelStyle: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            tabs: const [
                              Tab(text: "Claim Bonus"),
                              Tab(text: "Expired Bonus"),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 300,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Bagian Claim Bonus Pending
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<List<AfiliasiBonus>>(
                                        future: _pendingBonuses,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text(
                                              'Error: ${snapshot.error}',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.red),
                                            );
                                          } else if (!snapshot.hasData ||
                                              snapshot.data!.isEmpty) {
                                            return const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Belum ada bonus untuk diklaim.',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            );
                                          }

                                          final bonuses = snapshot.data!;
                                          return Column(
                                            children: bonuses.map((bonus) {
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                padding:
                                                    const EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Bonus Anda',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          ),
                                                          const SizedBox(
                                                              height: 5),
                                                          Text(
                                                            '${formatRupiah(bonus.bonusAmount)}\n'
                                                            'Expiry: ${DateFormat.yMMMEd().format(DateTime.parse(bonus.expiryDate))}',
                                                            style: GoogleFonts
                                                                .poppins(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 82,
                                                      height: 30,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          side: const BorderSide(
                                                              color: Color(
                                                                  0xFFF1F1F1),
                                                              width: 1),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        onPressed: bonus
                                                                    .status ==
                                                                'pending'
                                                            ? () => _claimBonus(
                                                                bonus.id)
                                                            : null,
                                                        child: Text(
                                                          'Claim',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: const Color(
                                                                0xFF74B11A),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12,
                                                          ),
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
                                    ],
                                  ),
                                ),
                              ),
                              // Tab Expired Bonus
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<List<AfiliasiBonus>>(
                                        future: _expiredBonuses,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text(
                                              'Error: ${snapshot.error}',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.red),
                                            );
                                          } else if (!snapshot.hasData ||
                                              snapshot.data!.isEmpty) {
                                            return const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Tidak ada bonus expired.',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            );
                                          }

                                          final bonuses = snapshot.data!;
                                          return Column(
                                            children: bonuses.map((bonus) {
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                padding:
                                                    const EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Bonus Anda',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          ),
                                                          const SizedBox(
                                                              height: 5),
                                                          Text(
                                                            '${formatRupiah(bonus.bonusAmount)}\n'
                                                            'Expiry: ${DateFormat.yMMMEd().format(DateTime.parse(bonus.expiryDate))}',
                                                            style: GoogleFonts
                                                                .poppins(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 15,
                                                        vertical: 5,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.transparent,
                                                        border: Border.all(
                                                          color: const Color(
                                                              0xFFF1F1F1),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Text(
                                                        'Expired',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
