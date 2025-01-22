import 'package:flutter/material.dart';
import 'package:frontend/services/address_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/user_provider.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller for form fields
  final TextEditingController _recipientNameController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  bool _isDefault = false;

  // Dropdown selected values
  String? _selectedCity;
  String? _selectedState;

  // List to store cities and states
  List<String> _cities = [];
  List<String> _states = [];

  // Flag for loading data
  bool _isLoadingCities = true;
  bool _isLoadingStates = true;

  @override
  void initState() {
    super.initState();
    _loadCitiesAndStates();
  }

  // Function to load cities and states data
  Future<void> _loadCitiesAndStates() async {
    try {
      // Fetch cities and states from the service (menggunakan List<String>)
      List<String> citiesData = await AddressService().getCities(context);
      List<String> statesData = await AddressService().getStates(context);

      // Extract city and state names into separate lists
      setState(() {
        _cities = citiesData; // List<String> sudah sesuai
        _states = statesData; // List<String> sudah sesuai
        _isLoadingCities = false;
        _isLoadingStates = false;
      });
    } catch (error) {
      setState(() {
        _isLoadingCities = false;
        _isLoadingStates = false;
      });
      // Handle error (e.g., show a message to the user)
      debugPrint("Error loading cities or states: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Tambah Alamat Baru',
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Other form fields...

              // Recipient Name
              TextFormField(
                controller: _recipientNameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  } else if (value.length < 4) {
                    return 'Nama Penerima must be at least 3 characters long';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.only(left: 28.0, top: 17, bottom: 17),
                  labelText: 'Nama Penerima',
                  labelStyle: GoogleFonts.poppins(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              // Phone Number
              TextFormField(
                controller: _phoneNumberController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Nomor telepon hanya boleh berisi angka';
                  } else if (value.length < 10 || value.length > 14) {
                    return 'Nomor telepon harus memiliki 10 hingga 14 digit';
                  }
                  return null; // Nomor telepon valid
                },
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.only(left: 28.0, top: 17, bottom: 17),
                  labelText: 'Nomor Telepon',
                  labelStyle: GoogleFonts.poppins(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              // Address Line 1
              TextFormField(
                controller: _addressLine1Controller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // Tidak ada pesan error jika kosong
                  } else if (value.length < 5) {
                    return 'Alamat Line 1 harus memiliki setidaknya 5 karakter';
                  } else if (value.length > 100) {
                    return 'Alamat Line 21tidak boleh lebih dari 100 karakter';
                  } else if (!RegExp(r'^[a-zA-Z0-9\s.,-]+$').hasMatch(value)) {
                    return 'Alamat Line 1 hanya boleh berisi huruf, angka, spasi, koma, titik, atau tanda hubung';
                  }
                  return null;
                },
                minLines: 3, // Jumlah minimum baris
                maxLines: null, // Tidak ada batasan jumlah maksimum baris
                keyboardType:
                    TextInputType.multiline, // Mendukung input multiline
                textInputAction: TextInputAction
                    .newline, // Memungkinkan Enter untuk baris baru
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 28.0, vertical: 20), // Tinggi padding
                  labelText: 'Alamat Line 1',
                  labelStyle: GoogleFonts.poppins(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              // Postal Code
              TextFormField(
                controller: _postalCodeController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode pos tidak boleh kosong';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.only(left: 28.0, top: 17, bottom: 17),
                  labelText: 'Kode Pos',
                  labelStyle: GoogleFonts.poppins(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              // Loading City dropdown or City selection
              _isLoadingCities
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color(0xFFCDCDCD), width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color(0xFFCDCDCD), width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.only(
                            left: 28.0, top: 17, bottom: 17),
                        labelStyle: GoogleFonts.poppins(color: Colors.grey),
                      ),
                      value: _selectedCity,
                      hint: Text(
                        'Pilih Kota', // Placeholder yang ditampilkan
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCity = newValue;
                        });
                      },
                      items: _cities.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan pilih kota';
                        }
                        return null;
                      },
                    ),

              const SizedBox(height: 10),
              // Loading State dropdown or State selection
              _isLoadingStates
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color(0xFFCDCDCD), width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color(0xFFCDCDCD), width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.only(
                            left: 28.0, top: 17, bottom: 17),
                        labelStyle: GoogleFonts.poppins(color: Colors.grey),
                      ),
                      value: _selectedState,
                      hint: Text(
                        'Pilih Provinsi', // Placeholder yang ditampilkan
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedState = newValue;
                        });
                      },
                      items: _states.map((String state) {
                        return DropdownMenuItem<String>(
                          value: state,
                          child: Text(state),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silakan pilih provinsi';
                        }
                        return null;
                      },
                    ),
              // Default Address Switch
              SwitchListTile(
                title: const Text("Jadikan Alamat Default"),
                value: _isDefault,
                onChanged: (bool newValue) {
                  setState(() {
                    _isDefault = newValue;
                    print("isDefault updated: $_isDefault"); // Debugging
                  });
                },
              ),

              // Save Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Menambahkan alamat dengan userId yang diambil dari provider
                    await AddressService().addAddress(
                      context: context,
                      userId: userProvider.userId ?? 0,
                      recipientName: _recipientNameController.text,
                      phoneNumber: _phoneNumberController.text,
                      addressLine1: _addressLine1Controller.text,
                      city: _selectedCity ?? '',
                      state: _selectedState ?? '',
                      postalCode: _postalCodeController.text,
                      isDefault: _isDefault,
                      supportedArea: true,
                    );

                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
