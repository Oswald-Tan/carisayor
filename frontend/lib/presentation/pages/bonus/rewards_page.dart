import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/presentation/pages/bonus/components/expires_page.dart';
import 'package:frontend/presentation/pages/bonus/components/referrals_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/data/model/total_bonus_model.dart';
import 'package:frontend/data/model/afiliasi_bonus_model.dart';
import 'package:frontend/data/services/total_bonus_service.dart';
import 'package:frontend/data/services/afiliasi_bonus_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:frontend/presentation/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

final currencyFormat =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

String formatRupiah(int value) {
  return currencyFormat.format(value).replaceAll('Rp', 'Rp. ');
}

String formatNumber(int value) {
  final format = NumberFormat('#,##0', 'id_ID');
  return format.format(value);
}

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage>
    with SingleTickerProviderStateMixin {
  final TotalBonusService _totalBonusService = TotalBonusService();
  final AfiliasiBonusService _afiliasiBonusService = AfiliasiBonusService();

  late Future<TotalBonus> _totalBonus;
  late Future<List<AfiliasiBonus>> _pendingBonuses;

  @override
  void initState() {
    super.initState();
    _totalBonus = _totalBonusService.getTotalBonus(context);
    _pendingBonuses = _afiliasiBonusService.getPendingBonuses(context);
  }

  Future<void> _claimBonus(int bonusId) async {
    try {
      await _afiliasiBonusService.claimBonus(context, bonusId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bonus berhasil diklaim!')),
        );
        Fluttertoast.showToast(
          msg: "Bonus berhasil diklaim!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color(0xFF74B11A),
          textColor: Colors.white,
          fontSize: 14.0,
        );
      }
      setState(() {
        _pendingBonuses = _afiliasiBonusService.getPendingBonuses(context);
      });
    } catch (e) {
      if (mounted) {
        // Menghapus "Exception:" dan menampilkan pesan error yang lebih bersih di SnackBar
        String errorMessage = e.toString().replaceAll('Exception:', '').trim();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _totalBonus = _totalBonusService.getTotalBonus(context);
      _pendingBonuses = _afiliasiBonusService.getPendingBonuses(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Rewards',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(
                Icons.info_outline,
                color: Colors.black,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  backgroundColor: Colors.white,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 50,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Cara Mendapatkan Reward 🎉',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Informasi tentang membagikan kode referral
                          Text(
                            '1️⃣ **Membagikan Kode Referral**',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Bagikan kode referral Anda kepada teman atau keluarga. Mereka akan mendapatkan bonus setelah melakukan transaksi pertama, dan Anda juga akan mendapatkan bonus sebagai pemberi referral.',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          const SizedBox(height: 16),

                          // Informasi tentang menukarkan bonus
                          Text(
                            '2️⃣ **Menukar Bonus ke Rupiah**',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Setelah Anda mengumpulkan cukup bonus, Anda dapat menukarkannya ke dalam bentuk uang rupiah. Bonus akan ditransfer ke rekening bank Anda sesuai dengan jumlah yang terakumulasi.',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          // const SizedBox(height: 6),
                          // Text(
                          //   '💡 Pastikan Anda sudah memverifikasi rekening bank Anda di akun profil untuk proses penarikan.',
                          //   style: GoogleFonts.poppins(
                          //       fontSize: 14, fontStyle: FontStyle.italic),
                          // ),
                          const SizedBox(height: 20),

                          // Tombol Tutup modal
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Tutup',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF0F1F5),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: const Color(0xFF74B11A),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Refer your friend &\nearn points',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            _buildReferralSection(),
            const SizedBox(height: 5),
            _buildProgressSection(),
            const SizedBox(height: 5),
            _buildMenuSection(context),
            const SizedBox(height: 20),
            _buildRewardCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralSection() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final referralCode = userProvider.referralCode ?? 'Referral Code';
        final textController = TextEditingController(text: referralCode);

        return Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: textController,
                  readOnly: true,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: const Color(0XFFeef0f4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.transparent, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.transparent, width: 1),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    labelStyle: GoogleFonts.poppins(color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: const Icon(size: 20, Icons.copy_all_rounded),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: referralCode));
                        Fluttertoast.showToast(
                          msg: "Kode referral disalin!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                          fontSize: 14.0,
                        );
                      },
                    ),
                  ),
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(size: 16, Icons.share),
                  label: Text(
                    'Share',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  onPressed: () {
                    const appUrl = "https://carisayor.co.id";
                    final referralMessage =
                        "🎉 Dapatkan bonus spesial dengan kode referral saya! 🎉\n\n"
                        "🆔 Kode Referral: *$referralCode*\n\n"
                        "📌 Klik tautan berikut untuk informasi lebih lanjut dan daftar sekarang: $appUrl\n\n"
                        "Jangan sampai ketinggalan! 🚀";

                    Share.share(referralMessage);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF74B11A),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressSection() {
    return FutureBuilder<TotalBonus>(
      future: _totalBonus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Ganti CircularProgressIndicator dengan efek Shimmer
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 150,
                              height: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 100,
                              height: 20,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 8,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final totalBonus = snapshot.data;
          final currentPoints = totalBonus?.totalBonus ?? 0;

          return Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/rp.png',
                        width: 48,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reward Bonus',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Rp. ${formatNumber(currentPoints)}',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Text('No Data Available');
        }
      },
    );
  }

  // Widget _buildGradientProgressBar(double progress) {
  //   return Stack(
  //     children: [
  //       Container(
  //         height: 8,
  //         decoration: BoxDecoration(
  //           color: const Color(0xFFF0F1F5),
  //           borderRadius: BorderRadius.circular(6),
  //         ),
  //       ),
  //       // Foreground Gradient Progress
  //       LayoutBuilder(
  //         builder: (context, constraints) {
  //           return Container(
  //             width:
  //                 constraints.maxWidth * progress, // Sesuai progress (700/1000)
  //             height: 8,
  //             decoration: BoxDecoration(
  //               gradient: const LinearGradient(
  //                 colors: [Color(0xFFABCF51), Color(0xFFF9B32D)],
  //                 begin: Alignment.centerLeft,
  //                 end: Alignment.centerRight,
  //               ),
  //               borderRadius: BorderRadius.circular(6),
  //             ),
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildMenuSection(BuildContext context) {
    return Row(
      children: [
        // Card pertama dengan Expanded
        Expanded(
          child: Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    // Center untuk menempatkan ikon dan teks di tengah
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        // Arahkan ke halaman Referrals
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ReferralPage()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center secara horizontal
                        children: [
                          const Icon(
                            Icons.people_alt_rounded,
                            color: Color(0xFFF9B32D),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Referrals',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Card kedua dengan Expanded
        Expanded(
          child: Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    // Center untuk menempatkan ikon dan teks di tengah
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        // Arahkan ke halaman Expires
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ExpiresPage()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center secara horizontal
                        children: [
                          const Icon(
                            Icons.access_time_filled_outlined,
                            color: Color(0xFFABCF51),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Expires',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRewardCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Rewards',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            IconButton(
              icon: const Icon(
                size: 18,
                Icons.info_outline,
                color: Colors.grey,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  backgroundColor: Colors.white,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 50,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Cara Mendapatkan Reward 🎉',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildRewardStep(
                              '1️⃣ Setiap transaksi minimal 200 poin atau Rp. 200.000, pemberi referral mendapat bonus.'),
                          _buildRewardStep(
                              '2️⃣ Level 1 (pengundang langsung) mendapat 10% dari 200 poin atau Rp. 200.000.'),
                          _buildRewardStep(
                              '3️⃣ Level 2 (pengundang Level 1) mendapat 5% dari 200 poin atau Rp. 200.000.'),
                          _buildRewardStep(
                              '4️⃣ Bonus berlaku selama 30 hari setelah diberikan.'),
                          const SizedBox(height: 16),
                          Text(
                            'Contoh Perhitungan Bonus:',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 6),
                          _buildExampleBonus(
                              '✅ Jika transaksi Anda 200 poin atau Rp. 200.000, pemberi referral Level 1 mendapat 20 poin (10%).'),
                          _buildExampleBonus(
                              '✅ Pemberi referral Level 2 mendapat 10 poin (5%).'),
                          const SizedBox(height: 16),
                          Text(
                            '🚀 Semakin banyak Anda mengajak teman, semakin besar bonus yang bisa Anda dapatkan! 🎁🔥',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5,
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Tutup',
                                style: GoogleFonts.poppins(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        FutureBuilder<List<AfiliasiBonus>>(
          future: _pendingBonuses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: GoogleFonts.poppins(color: Colors.red),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Belum ada reward untuk diklaim.',
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
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
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
                      SizedBox(
                        width: 100,
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: const BorderSide(
                                color: Color(0xFFF1F1F1), width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: bonus.status == 'pending'
                              ? () => _claimBonus(bonus.id)
                              : null,
                          child: Text(
                            'Redeem',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF74B11A),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
    );
  }

  Widget _buildRewardStep(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
      ),
    );
  }

// Helper widget for example bonus
  Widget _buildExampleBonus(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
      ),
    );
  }
}
