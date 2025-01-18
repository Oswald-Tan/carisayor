import 'package:flutter/material.dart';
import 'package:frontend/bonus/bonus_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/screens/send/send_screen.dart';
import 'package:frontend/screens/top_up/topup_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardSaldo extends StatefulWidget {
  const CardSaldo({super.key});

  @override
  _CardSaldoState createState() => _CardSaldoState();
}

class _CardSaldoState extends State<CardSaldo> {
  bool isSaldoVisible = false;

  Future<void> _reloadPoints(UserProvider userProvider) async {
    try {
      await userProvider.getUserData(userProvider.token!);
      setState(() {
        isSaldoVisible = !isSaldoVisible;
      });
    } catch (error) {
      // Handle error if needed
      print('Error reloading points: $error');
    }
  }

  void _showComingSoonModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          widthFactor: 1.0,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Coming Soon',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: const Color(0xFF1F2131),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'This feature will be available in future updates.',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF1F2131),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final saldo = userProvider.points ?? 0;

        return Container(
          margin: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 170,
                    decoration: const BoxDecoration(
                      color: Color(0xFF74B11A),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, top: 5),
                              child: Text(
                                'Poin CS Anda',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Transform.translate(
                                offset: const Offset(0.0, 15.0),
                                child: Image.asset(
                                  'assets/images/effect.png',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              Image.asset(
                                width: 20,
                                'assets/images/poin_cs.png',
                              ),
                              const SizedBox(width: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSaldoVisible)
                                    Text(
                                      saldo.toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  if (!isSaldoVisible)
                                    InkWell(
                                      onTap: () async {
                                        await _reloadPoints(userProvider);
                                      },
                                      child: Text(
                                        '•' * saldo.toString().length,
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                              InkWell(
                                onTap: () async {
                                  await _reloadPoints(userProvider);
                                },
                                child: Icon(
                                  isSaldoVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                            color: Color(0xFF589400),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildIconWithText(
                                  FontAwesomeIcons.plusCircle, // Top Up Icon
                                  'Top Up',
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const TopUpPage(),
                                      ),
                                    );
                                  },
                                ),
                                _buildIconWithText(
                                  FontAwesomeIcons.shareAlt, // Send Icon
                                  'Send',
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SendScreen(),
                                      ),
                                    );
                                  },
                                ),
                                _buildIconWithText(
                                  FontAwesomeIcons.qrcode, // Scan Icon
                                  'Scan',
                                  _showComingSoonModal,
                                ),
                                _buildIconWithText(
                                  FontAwesomeIcons.coins, // Bonus Icon
                                  'Bonus', // Changed 'Bayar' to 'Bonus'
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BonusScreen()),
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
          ),
        );
      },
    );
  }

  Widget _buildIconWithText(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF74B11A),
              size: 18,
            ),
          ), // Icon with color
          const SizedBox(height: 5),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
