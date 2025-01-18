import 'package:flutter/material.dart';
import 'package:frontend/screens/init_screen.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class Poin extends StatefulWidget {
  final ValueChanged<int?>? onValueChangedCallback;

  const Poin({Key? key, required this.onValueChangedCallback})
      : super(key: key);

  @override
  _PoinState createState() => _PoinState();
}

class _PoinState extends State<Poin> {
  int? selectedValue;
  List<int> poinValues = [10, 20, 30]; // Contoh nilai tetap
  int csPoin = 1000; // Contoh nilai tetap

  @override
  void initState() {
    super.initState();
    selectedValue = poinValues.isNotEmpty ? poinValues.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: selectedValue != null
                      ? () => handleCustomValueChanged(-1)
                      : null,
                  child: Container(
                    width: 19,
                    height: 19,
                    decoration: BoxDecoration(
                      color: selectedValue != null
                          ? const Color(0xFF1F2131)
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/poin_cs.png',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${selectedValue ?? 0}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: selectedValue != null
                            ? const Color(0xFF1F2131)
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: selectedValue != null
                      ? () => handleCustomValueChanged(1)
                      : null,
                  child: Container(
                    width: 19,
                    height: 19,
                    decoration: BoxDecoration(
                      color: selectedValue != null
                          ? const Color(0xFF1F2131)
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        for (int value in poinValues)
          PoinItem(
            value: value,
            isSelected: selectedValue == value,
            onPressed: () => handleValueChanged(value),
            csPoin: csPoin,
          ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: selectedValue != null ? handlePayment : null,
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: const Color(0xFF74B11A)),
          child: Text(
            'Bayar',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  void handleValueChanged(int value) {
    setState(() {
      selectedValue = (selectedValue == value) ? null : value;
    });

    widget.onValueChangedCallback?.call(selectedValue);
    print('Selected Value: $selectedValue');
  }

  void handleCustomValueChanged(int change) {
    setState(() {
      selectedValue = (selectedValue ?? 0) + change;
      if (selectedValue! < 0) {
        selectedValue = 0;
      }
    });

    widget.onValueChangedCallback?.call(selectedValue);
    print('Selected Value: $selectedValue');
  }

  void handlePayment() {
    // Implementasi logika pembayaran tanpa Firebase
    print("Melakukan pembayaran dengan poin: $selectedValue");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const InitScreen()),
    );
  }
}

class PoinItem extends StatelessWidget {
  final int value;
  final bool isSelected;
  final VoidCallback onPressed;
  final int csPoin;

  const PoinItem({
    super.key,
    required this.value,
    required this.isSelected,
    required this.onPressed,
    required this.csPoin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0XFF74B11A) : Colors.white,
            width: 2,
          ),
        ),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/poin_cs.png',
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    value.toString(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: const Color(0xFF1F2131),
                    ),
                  ),
                ],
              ),
              Text(
                'Rp. ${NumberFormat("#,###").format(value * csPoin)}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF1F2131),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
