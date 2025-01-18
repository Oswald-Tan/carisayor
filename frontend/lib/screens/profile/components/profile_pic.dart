import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/screens/profile/components/edit_profile.dart';
import 'package:shimmer/shimmer.dart';

class ProfileHeader extends StatelessWidget {
  final String profileImageUrl;
  final String name;
  final String email;

  const ProfileHeader({
    Key? key,
    required this.profileImageUrl,
    required this.name,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Row(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: profileImageUrl.isNotEmpty
                      ? NetworkImage(profileImageUrl)
                      : const AssetImage('assets/images/profile_user.jpg')
                          as ImageProvider<Object>,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Displaying name with shimmer effect if the name is empty
                  name.isNotEmpty
                      ? Text(
                          name,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF1F2131),
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 100,
                            height: 16,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  8), // Sesuaikan dengan kebutuhan Anda
                              color: Colors.white,
                            ),
                          ),
                        ),
                  const SizedBox(height: 4),
                  // Displaying email with shimmer effect if the email is empty
                  email.isNotEmpty
                      ? Text(
                          email,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFF828282),
                          ),
                        )
                      : Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 120,
                            height: 12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  6), // Sesuaikan dengan kebutuhan Anda
                              color: Colors.white,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.edit_outlined,
                color: Color(0xFF1F2131),
              ),
            ),
          ],
        );
      },
    );
  }
}
