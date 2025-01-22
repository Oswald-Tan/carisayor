import 'package:flutter/material.dart';
import 'package:frontend/services/address_service.dart';
import 'package:frontend/model/address_model.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/profile/components/add_address.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  late Future<List<Address>> futureAddresses;

  @override
  void initState() {
    super.initState();
    futureAddresses = fetchUserAddresses();
  }

  Future<List<Address>> fetchUserAddresses() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;

    if (userId != null) {
      return await AddressService().getUserAddresses(context, userId);
    }
    return [];
  }

  Future<void> _refreshAddresses() async {
    setState(() {
      futureAddresses = fetchUserAddresses();
    });
    await futureAddresses;
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
            color: const Color(0xFF1F2131),
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Display Addresses with Pull-to-Refresh
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshAddresses,
                color: const Color(0xFF74B11A),
                child: FutureBuilder<List<Address>>(
                  future: futureAddresses,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No addresses found"));
                    }

                    final addresses = snapshot.data!;

                    return ListView.builder(
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final address = addresses[index];

                        return Stack(
                          children: [
                            Card(
                              elevation: 0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                  color: Color(0xFFe9e8e8),
                                ),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                      text: address.recipientName,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: const Color(0xFF1F2131),
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' | ${address.phoneNumber}',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
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
                                                  color: Colors.green),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Alamat Utama',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.green,
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
                            Positioned(
                              top: 8,
                              right: 0,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  popupMenuTheme: PopupMenuThemeData(
                                    color: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(
                                        color: Colors.green,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                child: PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AddAddress(),
                                        ),
                                      );
                                    } else if (value == 'delete') {
                                      await AddressService().deleteAddress(
                                          context, address.id); // Address ID
                                      setState(() {
                                        futureAddresses = fetchUserAddresses();
                                      });
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          const Icon(Icons.edit,
                                              size: 16, color: Colors.blue),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Edit',
                                            style: GoogleFonts.poppins(),
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
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  icon: const Icon(Icons.more_vert),
                                  iconSize: 18,
                                ),
                              ),
                            )
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
                // Navigate to the AddAddressPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddAddress()),
                );
              },
              child: const Text("Tambah Alamat Baru"),
            ),
          ],
        ),
      ),
    );
  }
}
