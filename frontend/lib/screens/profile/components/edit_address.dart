import 'package:flutter/material.dart';
import 'package:frontend/model/address_model.dart';
import 'package:frontend/model/city_province_model.dart';
import 'package:frontend/services/address_service.dart';
import 'package:frontend/services/city_province_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/user_provider.dart';

class EditAddressPage extends StatefulWidget {
  final Address address;

  const EditAddressPage({super.key, required this.address});

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController recipientNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController addressLine1Controller;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController postalCodeController;
  bool isDefault = false;

  // Tambahkan state untuk Province dan City
  final ProvinceService _provinceService = ProvinceService();
  List<Province> _provinces = [];
  List<City> _cities = [];
  Province? _selectedProvince;
  City? _selectedCity;

  @override
  void initState() {
    super.initState();
    recipientNameController =
        TextEditingController(text: widget.address.recipientName);
    phoneNumberController =
        TextEditingController(text: widget.address.phoneNumber);
    addressLine1Controller =
        TextEditingController(text: widget.address.addressLine1);
    cityController = TextEditingController(text: widget.address.city);
    stateController = TextEditingController(text: widget.address.state);
    postalCodeController =
        TextEditingController(text: widget.address.postalCode);
    isDefault = widget.address.isDefault;

    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    try {
      final provinces = await _provinceService.fetchProvinces(context);
      setState(() {
        _provinces = provinces;
      });

      // Set the province and city after the provinces are loaded
      Province? selectedProvince = _provinces.firstWhere(
        (province) => province.name == widget.address.state,
        orElse: () => _provinces[0],
      );
      _onProvinceChanged(selectedProvince);
    } catch (error) {
      // Handle error
      print('Error: $error');
    }
  }

  void _onProvinceChanged(Province? selectedProvince) {
    setState(() {
      _selectedProvince = selectedProvince;
      _cities = selectedProvince?.cities ?? [];
      _selectedCity = null;
      // Update city and state controllers
      stateController.text = selectedProvince?.name ?? '';
      cityController.text = '';

      // Cari kota yang sesuai dengan widget.address.city dan pilih kota tersebut
      if (_cities.isNotEmpty) {
        City? selectedCity = _cities.firstWhere(
          (city) => city.name == widget.address.city,
          orElse: () => _cities[0], // Atur kota pertama jika tidak ditemukan
        );
        _onCityChanged(selectedCity);
      }
    });
  }

  void _onCityChanged(City? selectedCity) {
    setState(() {
      _selectedCity = selectedCity;
      cityController.text = selectedCity?.name ?? ''; // Update city controller
    });
  }

  @override
  void dispose() {
    recipientNameController.dispose();
    phoneNumberController.dispose();
    addressLine1Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  void updateAddress() async {
    if (_formKey.currentState!.validate()) {
      try {
        await AddressService().editAddress(
          context: context,
          id: widget.address.id,
          recipientName: recipientNameController.text,
          phoneNumber: phoneNumberController.text,
          addressLine1: addressLine1Controller.text,
          city: cityController.text,
          state: stateController.text,
          postalCode: postalCodeController.text,
          isDefault: isDefault,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Address updated successfully')),
          );

          // Kembali ke dua halaman sebelumnya
          // Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update address: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Alamat',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: recipientNameController,
                  decoration:
                      const InputDecoration(labelText: 'Recipient Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter recipient name' : null,
                ),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter phone number' : null,
                ),
                TextFormField(
                  controller: addressLine1Controller,
                  decoration:
                      const InputDecoration(labelText: 'Address Line 1'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter address line 1' : null,
                ),
                // Dropdown Province
                DropdownButtonFormField<Province>(
                  value: _selectedProvince ??
                      (_provinces.isNotEmpty ? _provinces[0] : null),
                  onChanged: _onProvinceChanged,
                  items: _provinces.map((Province province) {
                    return DropdownMenuItem<Province>(
                      value: province,
                      child: Text(province.name),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Province'),
                ),

                // Dropdown City
                DropdownButtonFormField<City>(
                  value:
                      _selectedCity ?? (_cities.isNotEmpty ? _cities[0] : null),
                  onChanged: _onCityChanged,
                  items: _cities.map((City city) {
                    return DropdownMenuItem<City>(
                      value: city,
                      child: Text(city.name),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'City'),
                ),

                TextFormField(
                  controller: postalCodeController,
                  decoration: const InputDecoration(labelText: 'Postal Code'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter postal code' : null,
                ),

                SwitchListTile(
                  title: const Text('Set as default address'),
                  value: isDefault,
                  onChanged: (value) => setState(() => isDefault = value),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: updateAddress,
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
