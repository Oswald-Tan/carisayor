import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/profile/components/header_profile.dart';
import 'package:frontend/presentation/pages/profile/components/menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF589400),
                Color(0xFF2E7D32),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: Column(
            children: [
              SizedBox(
                height: 205,
                child: ProfilePage(),
              ),
              SizedBox(height: 10),
              Menu()
            ],
          ),
        ),
      ),
    );
  }
}
