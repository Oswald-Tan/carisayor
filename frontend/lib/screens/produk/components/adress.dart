import 'package:flutter/material.dart';
import 'package:frontend/services/address_service.dart';
import 'package:frontend/model/address_model.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressWidget extends StatefulWidget {
  final int userId;

  const AddressWidget({super.key, required this.userId});

  @override
  _AddressWidgetState createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  Address? defaultAddress;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDefaultAddress();
  }

  Future<void> _fetchDefaultAddress() async {
    try {
      final address =
          await AddressService().getDefaultAddress(context, widget.userId);
      setState(() {
        defaultAddress = address;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error, maybe show a snackbar or dialog
      debugPrint("Error while fetching default address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : defaultAddress != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 7),
                  Align(
                    alignment:
                        Alignment.centerLeft, // Ensures text aligns to the left
                    child: Text(
                      "${defaultAddress!.addressLine1}, ${defaultAddress!.city}, ${defaultAddress!.state}, ${defaultAddress!.postalCode}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF1F2131),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Alamat belum dibuat!",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF1F2131),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
  }
}
