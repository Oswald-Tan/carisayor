import 'package:flutter/material.dart';
import 'package:frontend/screens/activity/activity_screen.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/screens/produk/produk_screen.dart';
import 'package:frontend/screens/profile/profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';

const Color inActiveIconColor = Color(0XFFC5EF86);

class InitScreen extends StatefulWidget {
  static String routeName = "/init";

  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int currentSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }

  final pages = [
    const HomeScreen(),
    const ProductScreen(),
    const Activity(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Content Pages
          IndexedStack(
            index: currentSelectedIndex,
            children: pages,
          ),
          // Floating Navigation Bar
          Positioned(
            bottom: 16.0, // Sesuaikan dengan keinginan Anda
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF74B11A),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(51, 22, 22, 22),
                    blurRadius: 8.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildFloatingIconButton(
                      Icons.other_houses_outlined, 'Home', 0),
                  buildFloatingIconButton(
                      Icons.shopping_bag_outlined, 'Shop', 1),
                  buildFloatingIconButton(Icons.history, 'Activity', 2),
                  buildFloatingIconButton(Icons.person_outline, 'Profile', 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFloatingIconButton(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        updateCurrentIndex(index);
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: currentSelectedIndex == index
                  ? Colors.white
                  : inActiveIconColor,
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: currentSelectedIndex == index
                    ? Colors.white
                    : inActiveIconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
