import 'package:flutter/material.dart';
import 'package:frontend/services/address_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/user_provider.dart';

import 'package:frontend/model/city_province_model.dart';
import 'package:frontend/services/city_province_service.dart';

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

  final ProvinceService _provinceService = ProvinceService();
  List<Province> _provinces = [];
  List<City> _cities = [];
  Province? _selectedProvince;
  City? _selectedCity;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    try {
      final provinces = await _provinceService.fetchProvinces(context);
      setState(() {
        _provinces = provinces;
      });
    } catch (error) {
      // Handle error
      print('Error: $error');
    }
  }

  void _onProvinceChanged(Province? selectedProvince) {
    setState(() {
      _selectedProvince = selectedProvince;
      _cities = selectedProvince?.cities ?? [];
      _selectedCity = null; // Reset city selection when province changes
    });
  }

  void _onCityChanged(City? selectedCity) {
    setState(() {
      _selectedCity = selectedCity;
    });
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
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 28.0),
                    child: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.only(left: 28.0, top: 17, bottom: 17),
                  labelText: 'Nama Penerima',
                  labelStyle: GoogleFonts.poppins(),
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
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 28),
                    child: Icon(Icons.phone, color: Colors.grey),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.only(left: 28.0, top: 17, bottom: 17),
                  labelText: 'Nomor Telepon',
                  labelStyle: GoogleFonts.poppins(),
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
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 28),
                    child: Icon(Icons.location_on, color: Colors.grey),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 28.0, vertical: 20), // Tinggi padding
                  labelText: 'Alamat Line 1',
                  labelStyle: GoogleFonts.poppins(),
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
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 28),
                    child: Icon(Icons.map, color: Colors.grey),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xFFCDCDCD), width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.only(left: 28.0, top: 17, bottom: 17),
                  labelText: 'Kode Pos',
                  labelStyle: GoogleFonts.poppins(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Dropdown City
                  Expanded(
                    child: DropdownButtonFormField<Province>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFFCDCDCD), width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFFCDCDCD), width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.only(
                            left: 28, top: 17, bottom: 17, right: 18),
                        labelStyle: GoogleFonts.poppins(color: Colors.grey),
                      ),
                      value: _selectedProvince,
                      onChanged: _onProvinceChanged,
                      hint:
                          Text('Select Province', style: GoogleFonts.poppins()),
                      items: _provinces.map((Province province) {
                        return DropdownMenuItem<Province>(
                          value: province,
                          child: Text(province.name),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(width: 10), // Gap antara dropdown

                  // Dropdown State
                  Expanded(
                    child: DropdownButtonFormField<City>(
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFFCDCDCD), width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFFCDCDCD), width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.only(
                            left: 28, top: 17, bottom: 17, right: 18),
                        labelStyle: GoogleFonts.poppins(color: Colors.grey),
                      ),
                      value: _selectedCity,
                      onChanged: _onCityChanged,
                      hint: Text(
                        'Select City',
                        style: GoogleFonts.poppins(),
                      ),
                      items: _cities.map((City city) {
                        return DropdownMenuItem<City>(
                          value: city,
                          child: Text(city.name),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

              // Default Address Switch
              SwitchListTile(
                title: const Text("Jadikan Alamat Default"),
                value: _isDefault,
                onChanged: (bool newValue) {
                  setState(() {
                    _isDefault = newValue;
                  });
                },
                activeColor: const Color(0xFF74B11A),
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.white,
                tileColor: Colors.white,
                selectedTileColor: Colors.blue.shade50,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
                      city: _selectedCity?.name ?? '',
                      state: _selectedProvince?.name ?? '',
                      postalCode: _postalCodeController.text,
                      isDefault: _isDefault,
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
