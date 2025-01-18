import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late String _profileImage;
  late String _currentUsername;
  late String _phoneNumber; // Added phone number
  late TextEditingController _usernameController;
  late TextEditingController
      _phoneNumberController; // Added phone number controller
  late bool _isUsernameChanged;
  late bool _isProfileImageChanged;
  late bool _isPhoneNumberChanged; // Added phone number changed flag

  @override
  void initState() {
    super.initState();
    _profileImage = '';
    _currentUsername = '';
    _phoneNumber = ''; // Initialize phone number
    _usernameController = TextEditingController();
    _phoneNumberController =
        TextEditingController(); // Initialize phone number controller
    _isUsernameChanged = false;
    _isProfileImageChanged = false;
    _isPhoneNumberChanged = false; // Initialize phone number changed flag
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Placeholder data loading logic (replace with local storage or any other data source)
    setState(() {
      _currentUsername = 'SampleUsername';
      _usernameController.text = _currentUsername;
      _phoneNumber = '1234567890';
      _phoneNumberController.text = _phoneNumber;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile.path;
        _isProfileImageChanged = true;
      });
    }
  }

  void _showImagePickerModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Pilih Foto',
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(
                  'Ambil foto dari gallery',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(
                  'Ambil foto dari kamera',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () {
        _showImagePickerModal(context);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            backgroundImage: _profileImage.isNotEmpty
                ? FileImage(File(_profileImage))
                : const AssetImage('assets/images/profile_user.jpg')
                    as ImageProvider<Object>,
          ),
          const SizedBox(height: 8),
          Text(
            'Ganti Foto Profil',
            style: GoogleFonts.poppins(
              color: const Color(0xFF1F2131),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text(
            'Edit Profile',
            style: GoogleFonts.poppins(
              color: const Color(0xFF1F2131),
              fontWeight: FontWeight.w600,
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
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProfileImage(),
              const SizedBox(height: 30),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _isUsernameChanged = true;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _isPhoneNumberChanged = true;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Spacer(),
              ElevatedButton(
                onPressed: (_isProfileImageChanged ||
                            (_isUsernameChanged &&
                                _usernameController.text.trim() !=
                                    _currentUsername) ||
                            (_isPhoneNumberChanged &&
                                _phoneNumberController.text.trim() !=
                                    _phoneNumber)) &&
                        _usernameController.text.trim().isNotEmpty &&
                        _usernameController.text.trim().length >= 4
                    ? () {
                        // Perform save or update operations here
                        setState(() {
                          _currentUsername = _usernameController.text.trim();
                          _phoneNumber = _phoneNumberController.text.trim();
                          _isUsernameChanged = false;
                          _isPhoneNumberChanged = false;
                          _isProfileImageChanged = false;
                        });
                        Fluttertoast.showToast(
                          msg: 'Profil berhasil diperbarui',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF74B11A),
                ),
                child: Text(
                  'Simpan Perubahan',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
