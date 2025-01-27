import 'package:frontend/screens/home/components/history.dart';
import 'package:frontend/screens/home/components/carousel.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/home/components/home_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
                    'CAS',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      final username = userProvider.username ?? 'User';
                      return Text(
                        'Hallo, $username!',
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
                child: const Column(
                  children: [
                    SizedBox(height: 10),
                    Expanded(
                      child: RiwayatScreen(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // CategoriesCarousel muncul setelah BahanCard
              const CategoriesCarousel(),
            ],
          ),
        ),
      ),
    );
  }
}
