import 'package:flutter/material.dart';
import 'package:frontend/screens/profile/components/alamat_saya.dart';
import 'package:google_fonts/google_fonts.dart';

class Menu extends StatelessWidget {
  final String appVersion;
  final VoidCallback onLogout;

  const Menu({
    super.key,
    required this.appVersion,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Akun Saya',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Menu 2: Tambahan Baru
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9), // Background abu-abu
              border: Border.all(
                color: const Color(0xFFD4D4D4), // Border abu-abu
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20), // Sudut membulat
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline_outlined,
                            color: Color(0xFF1F2131),
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Akun',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF1F2131),
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Color(0xFFB9B9B9),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: Color(0xFFCCCCCC),
                    thickness: 1,
                    height: 0,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigasi ke halaman alamat
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddressPage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFF1F2131),
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Alamat saya',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF1F2131),
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Color(0xFFB9B9B9),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Menu 2: Aplikasi
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Preferences',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9), // Background abu-abu
              border: Border.all(
                color: const Color(0xFFD4D4D4), // Border abu-abu
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20), // Sudut membulat
            ),
            child: Column(
              children: [
                // Versi Aplikasi
                GestureDetector(
                  onTap: () {
                    // Tambahkan aksi untuk menu tambahan di sini
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Color(0xFF1F2131),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Tentang Aplikasi',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF1F2131),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Divider
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: Color(0xFFCCCCCC),
                    thickness: 1,
                    height: 0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                      Text(
                        '$appVersion',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1F2131),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: Color(0xFFCCCCCC),
                    thickness: 1,
                    height: 0,
                  ),
                ),
                // Logout
                GestureDetector(
                  onTap: () {
                    // Menampilkan dialog konfirmasi custom
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
                                    onLogout();
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
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          size: 20,
                          Icons.logout,
                          color: Colors.red[400],
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Logout',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.red[400],
                          ),
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
    );
  }
}
