import 'package:flutter/material.dart';
import 'package:frontend/screens/login_register/login_screen.dart';
import 'package:frontend/screens/profile/components/profile_pic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/auth_provider.dart'; // Import AuthProvider

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class ProfileHeaderPlaceholder extends StatelessWidget {
  const ProfileHeaderPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: const ProfileHeader(
        profileImageUrl: "",
        name: "",
        email: "",
      ),
    );
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? appVersion;

  // Metode untuk logout pengguna menggunakan AuthProvider
  Future<void> _logout() async {
    try {
      // Gunakan AuthProvider untuk melakukan logout
      await Provider.of<AuthProvider>(context, listen: false).logout();
      Fluttertoast.showToast(
        msg: "Logout berhasil",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Arahkan pengguna ke halaman LoginScreen setelah logout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      print("Error during logout: $e");
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appVersion = packageInfo.version;
      });
    } catch (e) {
      print("Error getting app version: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String userName = "Not Available"; // Ganti dengan sumber data lain

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1F2131),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF0F1F5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<String>(
                future: Future.delayed(Duration(seconds: 1), () => userName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: const ProfileHeaderPlaceholder(),
                    );
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Error loading data',
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    return ProfileHeader(
                      profileImageUrl: '',
                      name: snapshot.data ?? 'Not Available',
                      email: "Not Available",
                    );
                  }
                },
              ),
            ),

            // Versi Aplikasi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: Image.asset('assets/images/logo_icon.png'),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Versi Aplikasi',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF1F2131),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        '$appVersion',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1F2131),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Logout Button
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text(
                            'Konfirmasi',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1F2131)),
                          ),
                          content: Text(
                            'Apakah Anda yakin ingin keluar?',
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF1F2131)),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Tutup dialog
                              },
                              child: Text(
                                'Tidak',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1F2131)),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await _logout();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ),
                              child: Text(
                                'Ya',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: Image.asset('assets/images/logout.png'),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Keluar',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFFE03C3C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }
}
