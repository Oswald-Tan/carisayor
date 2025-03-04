import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/presentation/pages/profile/components/edit_profile.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:frontend/presentation/providers/user_provider.dart';

class ProfileHeader extends StatelessWidget {
  final String profileImageUrl;
  final String username;
  final String email;

  const ProfileHeader({
    super.key,
    required this.profileImageUrl,
    required this.username,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: profileImageUrl.isNotEmpty
                      ? NetworkImage(profileImageUrl)
                      : const AssetImage('assets/images/profile_user.png')
                          as ImageProvider<Object>,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Username
            username.isNotEmpty
                ? Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                    final username = userProvider.username ?? 'User';

                    return Text(
                      username,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  })
                : Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 120,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                  ),
            const SizedBox(height: 8),

            // Email
            email.isNotEmpty
                ? Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      final email = userProvider.email ?? 'User';
                      return Text(
                        email,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF828282),
                        ),
                      );
                    },
                  )
                : Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 150,
                      height: 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                  ),
            const SizedBox(height: 16),

            // Edit Button
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.black, // Warna latar belakang hitam
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Sudut membulat
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
              ),
              child: Text(
                'Edit Profile',
                style: GoogleFonts.poppins(
                  color: Colors.white, // Warna teks putih
                  fontSize: 12, // Ukuran teks
                  fontWeight: FontWeight.w600, // Ketebalan teks
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
