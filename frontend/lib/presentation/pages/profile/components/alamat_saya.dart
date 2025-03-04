import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/profile/components/edit_address.dart';
import 'package:frontend/data/services/address_service.dart';
import 'package:frontend/data/model/address_model.dart';
import 'package:frontend/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/presentation/pages/profile/components/add_address.dart';
import 'package:shimmer/shimmer.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  AddressPageState createState() => AddressPageState();
}

class AddressPageState extends State<AddressPage> {
  late Future<List<Address>> futureAddresses;

  @override
  void initState() {
    super.initState();
    futureAddresses = fetchUserAddresses();
  }

  // Fetch user addresses
  Future<List<Address>> fetchUserAddresses() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;

    if (userId != null) {
      return await AddressService().getUserAddresses(context, userId);
    }
    return [];
  }

  // Refresh addresses list
  Future<void> _refreshAddresses() async {
    setState(() {
      futureAddresses = fetchUserAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Alamat',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF0F1F5),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Display Addresses with Pull-to-Refresh
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshAddresses,
                color: const Color(0xFF74B11A),
                backgroundColor: Colors.white,
                child: FutureBuilder<List<Address>>(
                  future: futureAddresses,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListView.builder(
                          itemCount:
                              snapshot.hasData ? snapshot.data!.length : 5,
                          itemBuilder: (context, index) {
                            return _buildShimmerItem();
                          },
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text(
                        "No addresses found",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ));
                    }

                    final addresses = snapshot.data!;
                    return ListView.builder(
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final address = addresses[index];

                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                      text: address.recipientName.length > 15
                                          ? '${address.recipientName.substring(0, 15)}...'
                                          : address.recipientName,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: const Color(0xFF1F2131),
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' | ${address.phoneNumber}',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${address.addressLine1}, ${address.city}, ${address.state} ${address.postalCode}',
                                        style: GoogleFonts.poppins(),
                                      ),
                                      if (address.isDefault)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: const Color(0xFF74B11A),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Alamat Utama',
                                                style: GoogleFonts.poppins(
                                                  color:
                                                      const Color(0xFF74B11A),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  popupMenuTheme: PopupMenuThemeData(
                                    color: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: 1,
                                      ),
                                    ),
                                    textStyle: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                ),
                                child: PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditAddressPage(address: address),
                                        ),
                                      );
                                    } else if (value == 'delete') {
                                      debugPrint(
                                          'Deleting Address ID: ${address.id}');

                                      bool success = await AddressService()
                                          .deleteAddress(context, address.id);

                                      if (success) {
                                        Fluttertoast.showToast(
                                          msg: "Alamat berhasil dihapus!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          backgroundColor:
                                              const Color(0xFF74B11A),
                                          textColor: Colors.white,
                                          fontSize: 14.0,
                                        );

                                        setState(() {
                                          futureAddresses =
                                              fetchUserAddresses();
                                        });
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "Gagal menghapus alamat!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 14.0,
                                        );
                                      }
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          const Icon(Icons.edit,
                                              size: 16, color: Colors.orange),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Edit',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          const Icon(Icons.delete,
                                              size: 16,
                                              color: Color(0xFFF3463A)),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Delete',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  icon: const Icon(Icons.more_vert),
                                  iconSize: 18,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            // Add New Address Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddAddress()),
                );
              },
              child: Text(
                "New Address",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildShimmerItem() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200,
              height: 16,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 14,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 4),
            Container(
              width: 150,
              height: 14,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 12),
            Container(
              width: 100,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
