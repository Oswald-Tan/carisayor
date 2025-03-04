import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend/presentation/providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Background Header dengan ClipPath
            Padding(
              padding: const EdgeInsets.only(bottom: 45),
              child: ClipPath(
                clipper: ClipPathClass(),
                child: Container(
                  height: 205, // Tinggi header
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft, // Mulai dari kiri
                      end: Alignment.centerRight, // Berakhir di kanan
                      colors: [
                        Color(0xFF589400), // Warna hijau
                        Color(0xFF2E7D32), // Warna hijau lebih gelap
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Profile Image di Tengah Header
            Positioned(
              top: 75,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile_user.png',
                        fit: BoxFit.cover,
                        width: 92,
                        height: 92,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Consumer<UserProvider>(
                      builder: (context, userProvider, child) {
                    final fullname = userProvider.fullname ?? 'User';

                    return Text(
                      fullname,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Consumer<UserProvider>(
                        builder: (context, userProvider, child) {
                      final referralCode =
                          userProvider.referralCode ?? 'Referral Code';

                      return Text(
                        referralCode,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom ClipPath untuk Header
class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60); // Garis bawah ClipPath
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback press;
  final Color textColor; // Tambahkan parameter untuk warna teks
  final Color iconColor;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.press,
    this.textColor = const Color(0xFF1F2131), // Default color
    this.iconColor = const Color(0xFF1F2131),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: press, // Menangani klik tanpa efek tambahan
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 22,
                      color: const Color(0xFF1F2131),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    text,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2131),
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: Color(0xFF1F2131),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
