import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/services/address_service.dart';
import 'package:frontend/model/address_model.dart';

class AddressWidget extends StatefulWidget {
  final int userId;

  const AddressWidget({super.key, required this.userId});

  @override
  _AddressWidgetState createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  late Future<Address?> _defaultAddress;

  @override
  void initState() {
    super.initState();
    // Memanggil fungsi untuk mendapatkan alamat default
    _defaultAddress =
        AddressService().getDefaultAddress(context, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Address?>(
      future: _defaultAddress,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No default address found.'));
        } else {
          // Debug output
          debugPrint('Default Address: ${snapshot.data}');

          Address defaultAddress = snapshot.data!;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF1F2131),
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Alamat',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFF1F2131),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: Text(
                    "${defaultAddress.addressLine1}, ${defaultAddress.city}, ${defaultAddress.state}, ${defaultAddress.postalCode}",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF1F2131),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
