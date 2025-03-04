import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                "Kebijakan Privacy",
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
            // _buildSectionTitle('Privacy Policy'),
            _buildSectionContent(
              '''1. Informasi yang Kami Kumpulkan
Kami mengumpulkan informasi pribadi yang Anda berikan kepada kami ketika membuat akun, melakukan pembelian, atau menggunakan fitur lain di aplikasi kami. Informasi ini termasuk, namun tidak terbatas pada, nama, alamat email, nomor telepon, alamat pengiriman, dan informasi pembayaran. Kami juga dapat mengumpulkan data teknis seperti alamat IP, jenis perangkat, dan data penggunaan aplikasi.

2. Penggunaan Informasi Pribadi
Kami menggunakan informasi pribadi Anda untuk memproses transaksi, memberikan layanan pelanggan, dan mengirimkan pembaruan atau penawaran terkait produk dan layanan kami. Kami juga dapat menggunakan data untuk meningkatkan pengalaman pengguna, menyesuaikan konten, dan menganalisis penggunaan aplikasi untuk tujuan pengembangan.

3. Pengelolaan E-wallet
Jika Anda menggunakan e-wallet di aplikasi kami, kami akan mengumpulkan dan menyimpan informasi terkait transaksi keuangan Anda. Ini termasuk saldo e-wallet Anda, riwayat transaksi, dan informasi pembayaran. Informasi ini akan digunakan untuk memproses pembayaran, pengisian ulang saldo, dan melacak transaksi dalam aplikasi.

4. Perlindungan Data
Kami berkomitmen untuk melindungi data pribadi Anda. Kami menggunakan berbagai langkah keamanan, termasuk enkripsi, untuk melindungi informasi pribadi yang Anda kirimkan kepada kami. Kami juga membatasi akses ke data pribadi hanya kepada mereka yang perlu mengetahuinya untuk menjalankan layanan kami.

5. Pengungkapan Informasi kepada Pihak Ketiga
Kami tidak akan membagikan informasi pribadi Anda kepada pihak ketiga kecuali dalam kasus-kasus tertentu, seperti ketika diperlukan untuk memproses pembayaran, mengirimkan produk, atau memenuhi kewajiban hukum. Kami bekerja dengan mitra yang berwenang untuk memastikan bahwa data Anda tetap aman.

6. Pembaruan Kebijakan
Kami berhak untuk memperbarui kebijakan privasi ini sewaktu-waktu. Pembaruan akan diumumkan melalui aplikasi atau situs web kami, dan kebijakan yang diperbarui akan berlaku segera setelah diposting.

7. Hak Anda
Anda memiliki hak untuk mengakses, memperbaiki, atau menghapus informasi pribadi Anda. Jika Anda ingin mengelola pengaturan privasi atau meminta informasi tentang data yang kami simpan, silakan hubungi kami melalui kontak yang tersedia.
              ''',
            )
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
