import 'package:frontend/presentation/pages/home/components/history.dart';
import 'package:frontend/presentation/pages/home/components/carousel.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/home/components/home_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend/presentation/providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  final GlobalKey<RiwayatScreenState> riwayatKey = GlobalKey();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF589400),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Carisayor',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      final fullname = userProvider.fullname ?? 'User';
                      return Text(
                        'Hello, $fullname!',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/cs.png',
                  width: 25,
                ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await riwayatKey.currentState?.refreshData();
            userProvider.getUserData(userProvider.token!);
          },
          color: const Color(0xFF74B11A),
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Column(
              children: [
                const SizedBox(
                  height: 170,
                  child: Header(),
                ),
                const SizedBox(height: 20),
                Container(
                  width: screenWidth,
                  height: 312,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F1F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: RiwayatScreen(key: riwayatKey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 0),

                // CategoriesCarousel muncul setelah BahanCard
                const CategoriesCarousel(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
