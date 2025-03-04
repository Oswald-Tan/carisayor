import 'package:flutter/material.dart';
import 'package:frontend/data/services/address_service.dart';
import 'package:frontend/data/model/address_model.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressWidget extends StatefulWidget {
  final int userId;

  const AddressWidget({super.key, required this.userId});

  @override
  AddressWidgetState createState() => AddressWidgetState();
}

class AddressWidgetState extends State<AddressWidget> {
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
                    alignment: Alignment.centerLeft,
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
                      "Anda belum memiliki alamat utama! Harap tambahkan alamat terlebih dahulu dengan cara klik Change sebelum melakukan pemesanan. Pastikan alamat yang dimasukkan lengkap dan benar untuk kelancaran pengiriman pesanan Anda.",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
  }
}
