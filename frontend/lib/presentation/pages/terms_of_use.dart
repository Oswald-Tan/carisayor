import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFF0F1F5),

        centerTitle: true,
        // automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Terms of Use",
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2131),
                ),
              ),
            ),
            Center(
              child: Text(
                "Carisayor",
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2131),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Container(
                width: 70,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFF74B11A),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // _buildSectionTitle('Terms of Use'),
            _buildSectionContent(
              '''1. Penerimaan Syarat dan Ketentuan
Dengan mengakses atau menggunakan aplikasi e-commerce kami, Anda setuju untuk mematuhi semua syarat dan ketentuan yang tercantum dalam perjanjian ini. Jika Anda tidak setuju dengan syarat dan ketentuan ini, harap jangan menggunakan aplikasi kami.

2. Penggunaan Layanan
Aplikasi ini memungkinkan Anda untuk membeli produk, menggunakan e-wallet, dan menikmati layanan lainnya. Anda bertanggung jawab untuk menjaga kerahasiaan akun dan kata sandi Anda. Anda setuju untuk tidak menggunakan aplikasi kami untuk tujuan ilegal atau tidak sah.

3. Pendaftaran Akun
Untuk menggunakan fitur tertentu di aplikasi, Anda harus membuat akun. Anda bertanggung jawab untuk memberikan informasi yang akurat dan menjaga keamanan akun Anda. Anda juga setuju untuk memberi tahu kami jika ada aktivitas yang tidak sah di akun Anda.

4. Pembayaran dan Transaksi
Kami menyediakan layanan pembayaran dan transaksi melalui e-wallet. Semua transaksi dilakukan dengan cara yang aman, namun Anda bertanggung jawab untuk memeriksa riwayat transaksi Anda dan memastikan bahwa informasi pembayaran yang diberikan adalah benar. Semua transaksi dianggap final dan tidak dapat dibatalkan setelah diproses.

5. Pembaruan dan Perubahan Kebijakan
Kami berhak untuk memperbarui atau mengubah syarat dan ketentuan ini kapan saja tanpa pemberitahuan sebelumnya. Anda akan diberitahu tentang perubahan tersebut melalui aplikasi atau email, dan Anda setuju untuk mematuhi versi terbaru dari syarat dan ketentuan ini.

6. Penghentian Akun
Kami berhak untuk menangguhkan atau menghentikan akun Anda jika Anda melanggar syarat dan ketentuan ini. Anda dapat menutup akun Anda kapan saja dengan menghubungi tim dukungan kami.

7. Pembatasan Tanggung Jawab
Kami tidak bertanggung jawab atas kerugian atau kerusakan yang timbul dari penggunaan aplikasi kami, termasuk kesalahan dalam transaksi pembayaran atau penggunaan e-wallet. Kami berusaha memberikan layanan terbaik, namun kami tidak dapat menjamin bahwa aplikasi akan bebas dari kesalahan atau gangguan.

8. Penggunaan E-wallet
Sebagai bagian dari layanan kami, Anda dapat menggunakan e-wallet untuk melakukan pembelian dan transaksi lainnya. Anda bertanggung jawab untuk menjaga keamanan saldo e-wallet Anda. Kami tidak bertanggung jawab atas kerugian yang disebabkan oleh penggunaan yang tidak sah atau kesalahan transaksi.

9. Hukum yang Berlaku
Syarat dan ketentuan ini diatur oleh hukum yang berlaku di negara kami. Segala perselisihan yang timbul akan diselesaikan melalui pengadilan yang berwenang.
              ''',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        content,
        style: GoogleFonts.poppins(
          fontSize: 16,
          height: 1.6,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
