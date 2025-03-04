import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:frontend/presentation/pages/send/components/info_send.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});
  static String routeName = "/send";

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  String phoneNumberPenerima = '';
  int jumlahCSPoin = 0;
  String poinAnda = '0';

  @override
  void initState() {
    super.initState();
  }

  Future<bool> konfirmasiKirimPoinDialog() async {
    return await showDialog(
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
            'Apakah Anda yakin ingin mengirim poin Anda?',
            style: GoogleFonts.poppins(color: const Color(0xFF1F2131)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2131)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Kirim',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2131)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text(
            'Send',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2131),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF1F2131),
              size: 14,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: const Color(0xFFF0F1F5),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Poin CS Anda',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: const Color(0xFF1F2131),
                              ),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/poin_cs.png',
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  poinAnda,
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1F2131),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Image.asset(
                          'assets/images/cs.png',
                          width: 24,
                          height: 24,
                          color: const Color(0XFF74B11A),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const InfoSend(),
                const SizedBox(height: 40),
                TextFormField(
                  onChanged: (value) {
                    phoneNumberPenerima = value;
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    filled: true,
                    fillColor: const Color(0xFFF0F1F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFF8264B1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    contentPadding:
                        const EdgeInsets.only(left: 28.0, top: 17, bottom: 17),
                    labelText: 'Nomor Penerima',
                    labelStyle: GoogleFonts.poppins(color: Colors.grey),
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(right: 28),
                      child: Icon(Icons.phone, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      jumlahCSPoin = int.parse(value);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp(r'[.,-]'), // Menyaring simbol titik dan koma
                    ),
                  ],
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    filled: true,
                    fillColor: const Color(0xFFF0F1F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFF8264B1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    contentPadding:
                        const EdgeInsets.only(left: 28.0, top: 17, bottom: 17),
                    labelText: 'Jumlah CS Poin',
                    labelStyle: GoogleFonts.poppins(color: Colors.grey),
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(right: 28),
                      child: Icon(Icons.point_of_sale_outlined,
                          color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    if (phoneNumberPenerima.isNotEmpty) {
                      bool konfirmasi = await konfirmasiKirimPoinDialog();
                      if (konfirmasi) {
                        (phoneNumberPenerima, jumlahCSPoin);
                      } else {
                        debugPrint('Pengguna membatalkan pengiriman poin');
                      }
                    } else {
                      debugPrint('Nomor penerima tidak boleh kosong');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF74B11A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                  ),
                  child: Text(
                    'Kirim',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
