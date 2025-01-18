import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/screens/bayar/components/bayar.dart';
// import 'package:frontend/screens/bayar/components/info_bayar.dart';
import 'package:frontend/screens/bayar/components/poin.dart';

class BayarScreen extends StatefulWidget {
  static String routeName = "/bayar";

  const BayarScreen({super.key});

  @override
  _BayarScreenState createState() => _BayarScreenState();
}

class _BayarScreenState extends State<BayarScreen> {
  int totalValue = 0;
  int? selectedValue;

  void handlePoinSelected(int? value) {
    setState(() {
      selectedValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'Pembayaran',
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const InfoBayar(),
                // const SizedBox(height: 20),
                Bayar(
                  totalValue: totalValue,
                  selectedValue: selectedValue,
                  onValueChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  onAdd: () {
                    setState(() {
                      totalValue += 1;
                    });
                  },
                  onRemove: () {
                    setState(() {
                      totalValue -= 1;
                      if (totalValue < 0) totalValue = 0;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Poin(
                  onValueChangedCallback: (value) {
                    setState(() {
                      totalValue = value ?? 0;
                    });
                    handlePoinSelected(value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
