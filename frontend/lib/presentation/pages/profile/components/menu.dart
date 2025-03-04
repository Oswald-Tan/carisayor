import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/login_register/login_screen.dart';
import 'package:frontend/presentation/pages/privacy_policy.dart';
import 'package:frontend/presentation/pages/profile/components/alamat_saya.dart';
import 'package:frontend/presentation/pages/profile/components/bank_account.dart';
import 'package:frontend/presentation/pages/profile/components/edit_profile.dart';
import 'package:frontend/presentation/pages/terms_of_use.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:frontend/presentation/providers/auth_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Menu extends StatefulWidget {
  const Menu({
    super.key,
  });

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Future<void> _logout() async {
    try {
      // Gunakan AuthProvider untuk melakukan logout
      await Provider.of<AuthProvider>(context, listen: false).logout();
      Fluttertoast.showToast(
        msg: "Logout berhasil",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0,
      );

      // Arahkan pengguna ke halaman LoginScreen setelah logout
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      debugPrint("Error during logout: $e");
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  String? appVersion;

  Future<void> _getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appVersion = packageInfo.version;
      });
    } catch (e) {
      debugPrint("Error getting app version: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   margin: const EdgeInsets.only(left: 15, bottom: 10),
              //   child: Text("Akun",
              //       style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              // ),
              SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.9, // Atur lebar agar tidak infinity
                child: ProfileMenuItem(
                  icon: FontAwesomeIcons.solidUser,
                  text: "Profil Saya",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ProfileMenuItem(
                  icon: FontAwesomeIcons.locationDot,
                  text: "Alamat Saya",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddressPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ProfileMenuItem(
                  icon: FontAwesomeIcons.moneyCheckDollar,
                  text: "Nomor Rekening",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BankAccountPage(),
                      ),
                    );
                  },
                ),
              ),
              // const SizedBox(height: 10),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.9,
              //   child: ProfileMenuItem(
              //     icon: FontAwesomeIcons.phone,
              //     text: "Pusat Bantuan",
              //     press: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const AddressPage(),
              //         ),
              //       );
              //     },
              //   ),
              // ),
              const SizedBox(height: 20),
              // Container(
              //   margin: const EdgeInsets.only(left: 15, bottom: 10, top: 10),
              //   child: Text("Pengaturan & Informasi",
              //       style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              // ),
              const Divider(
                color: Color(0xFFE5E5E7),
                thickness: 1,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ProfileMenuItem(
                  icon: FontAwesomeIcons.shieldHalved,
                  text: "Privacy Policy",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ProfileMenuItem(
                  icon: FontAwesomeIcons.solidFileLines,
                  text: "Terms of Use",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TermsOfUseScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Sudut membulat
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Judul dialog
                              Text(
                                'Konfirmasi Logout',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Konten dialog
                              Text(
                                'Apakah Anda yakin ingin logout?',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),

                              // Tombol Batal
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Tutup dialog
                                },
                                child: Text(
                                  'Batal',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Tombol Logout
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _logout();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8EC61D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 30,
                                  ),
                                ),
                                child: Text(
                                  'Logout',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
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
                            FontAwesomeIcons.rightFromBracket,
                            size: 16,
                            color: Colors.red[400],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Logout",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.red[400],
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: Colors.red[400],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  appVersion != null ? "Versi $appVersion" : "Tidak Diketahui",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
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
                    size: 16,
                    color: const Color(0xFF404245),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF404245),
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: Color(0xFF404245),
            ),
          ],
        ),
      ),
    );
  }
}
