import 'package:flutter/material.dart';
import 'package:frontend/services/user_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
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
  late String _phoneNumber;
  late TextEditingController _usernameController;
  late TextEditingController _phoneNumberController;
  late bool _isUsernameChanged;
  late bool _isProfileImageChanged;
  late bool _isPhoneNumberChanged;

  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _profileImage = '';
    _currentUsername = '';
    _phoneNumber = '';
    _usernameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _isUsernameChanged = false;
    _isProfileImageChanged = false;
    _isPhoneNumberChanged = false;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _currentUsername = userProvider.username ?? 'SampleUsername';
      _usernameController.text = _currentUsername;
      _phoneNumber = userProvider.phoneNumber ?? '1234567890';
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

  Future<void> _updateUserProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId ?? 0; // Default to 0 if null

    final response = await _userService.updateUser(
      context,
      userId,
      _usernameController.text.trim(),
      _phoneNumberController.text.trim(),
    );

    if (response['status']) {
      Fluttertoast.showToast(msg: response['message']);

      // Update local state with the new values after a successful update
      setState(() {
        _currentUsername = _usernameController.text.trim();
        _phoneNumber = _phoneNumberController.text.trim();
        _isUsernameChanged = false;
        _isPhoneNumberChanged = false;
        _isProfileImageChanged = false;
      });

      // Update the UserProvider to keep it in sync with the local state
      userProvider.updateUsername(_usernameController.text.trim());
      userProvider.updatePhoneNumber(_phoneNumberController.text.trim());
    } else {
      Fluttertoast.showToast(msg: response['message']);
    }
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
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProfileImage(),
              const SizedBox(height: 30),
              TextFormField(
                controller: _usernameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // No error message when the field is empty
                  } else if (value.length < 4) {
                    return 'Username must be at least 4 characters long';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  // hintText: 'Enter your username',
                  // hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 28.0),
                    child: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
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
                  labelText: 'Username',
                  labelStyle: GoogleFonts.poppins(color: Colors.grey),
                ),
                onChanged: (value) {
                  setState(() {
                    _isUsernameChanged = true;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneNumberController,
                autovalidateMode: AutovalidateMode.onUserInteraction,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // No error message when the field is empty
                  }
                  // Add phone number validation logic if needed
                  return null;
                },
                keyboardType: TextInputType.phone, // Set keyboard type to phone
                decoration: InputDecoration(
                  // hintText: 'Enter your phone number',
                  // hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: Colors.white,
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
                  labelText: 'Phone Number',
                  labelStyle: GoogleFonts.poppins(color: Colors.grey),
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 28),
                    child: Icon(Icons.phone, color: Colors.grey),
                  ),
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
                    ? () async {
                        await _updateUserProfile();
                        setState(() {
                          _currentUsername = _usernameController.text.trim();
                          _phoneNumber = _phoneNumberController.text.trim();
                          _isUsernameChanged = false;
                          _isPhoneNumberChanged = false;
                          _isProfileImageChanged = false;
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF74B11A),
                ),
                child: Text(
                  'Update',
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
