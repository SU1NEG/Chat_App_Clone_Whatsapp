import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';
import 'main_chat_page.dart';
import 'person_page.dart';
import 'settings_page.dart';
import 'package:path/path.dart' as path;

class ProfilePage extends StatefulWidget {
  final String firstName;
  final String nickname;
  final String email;
  final Function(bool) toggleTheme;
  final Function(Locale) changeLanguage;
  final Function(String) changeNotificationSound;
  final bool isDarkMode;
  final String selectedNotificationSound;

  ProfilePage({
    required this.firstName,
    required this.nickname,
    required this.email,
    required this.toggleTheme,
    required this.changeLanguage,
    required this.changeNotificationSound,
    required this.isDarkMode,
    required this.selectedNotificationSound,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _nicknameController;
  late TextEditingController _emailController;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool _isEditingFirstName = false;
  bool _isEditingNickname = false;
  bool _isEditingEmail = false;

  final FirestoreService _firestoreService = FirestoreService();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _nicknameController = TextEditingController(text: widget.nickname);
    _emailController = TextEditingController(text: widget.email);
    _currentUser = FirebaseAuth.instance.currentUser;
    _loadProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Kameradan Fotoğraf Çek'),
              onTap: () async {
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.camera);
                Navigator.pop(context, pickedFile);
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Galeriden Fotoğraf Seç'),
              onTap: () async {
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context, pickedFile);
              },
            ),
          ],
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      if (isEmailValid()) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('firstName', _firstNameController.text);
        await prefs.setString('nickname', _nicknameController.text);
        await prefs.setString('email', _emailController.text);

        if (_image != null) {
          final directory = await getApplicationDocumentsDirectory();
          final fileName = path.basename(_image!.path);
          final newPath = path.join(directory.path, fileName);
          await _image!.copy(newPath);
          await prefs.setString('profileImagePath', newPath);
        }

        if (_currentUser != null) {
          // Update Firestore user data
          await _firestoreService.updateUser(_currentUser!);
        }

        print('Profil kaydedildi');
        setState(() {
          _isEditingFirstName = false;
          _isEditingNickname = false;
          _isEditingEmail = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Profil başarıyla kaydedildi."),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Geçerli bir e-posta adresi girin."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lütfen geçerli bir e-posta girin."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool isEmailValid() {
    final email = _emailController.text;
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_currentUser != null) {
      final userData = await _firestoreService.getUser(_currentUser!.uid);

      setState(() {
        _firstNameController.text = userData['displayName'] ?? widget.firstName;
        _nicknameController.text =
            prefs.getString('nickname') ?? widget.nickname;
        _emailController.text = userData['email'] ?? widget.email;

        final imagePath = prefs.getString('profileImagePath');
        if (imagePath != null) {
          _image = File(imagePath);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      _image == null
                          ? CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(
                                  'https://img.freepik.com/free-photo/close-up-smiley-man-taking-selfie_23-2149155156.jpg'),
                            )
                          : CircleAvatar(
                              radius: 80,
                              backgroundImage: FileImage(_image!),
                            ),
                      SizedBox(height: 10),
                      IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.orange),
                        onPressed: _pickImage,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _buildEditableField(
                    'First Name', _firstNameController, _isEditingFirstName,
                    () {
                  setState(() {
                    _isEditingFirstName = !_isEditingFirstName;
                  });
                }),
                SizedBox(height: 20),
                _buildEditableField(
                    'Nickname', _nicknameController, _isEditingNickname, () {
                  setState(() {
                    _isEditingNickname = !_isEditingNickname;
                  });
                }),
                SizedBox(height: 20),
                _buildEditableField(
                    'Email Address', _emailController, _isEditingEmail, () {
                  setState(() {
                    _isEditingEmail = !_isEditingEmail;
                  });
                }, isEmail: true),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white),
                      child: Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mesajlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Kişiler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainChatPage(
                  toggleTheme: widget.toggleTheme,
                  changeLanguage: widget.changeLanguage,
                  changeNotificationSound: widget.changeNotificationSound,
                  isDarkMode: widget.isDarkMode,
                  selectedNotificationSound: widget.selectedNotificationSound,
                ),
              ),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonPage(
                  toggleTheme: widget.toggleTheme,
                  changeLanguage: widget.changeLanguage,
                  changeNotificationSound: widget.changeNotificationSound,
                  isDarkMode: widget.isDarkMode,
                  selectedNotificationSound: widget.selectedNotificationSound,
                ),
              ),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPage(
                  toggleTheme: widget.toggleTheme,
                  changeLanguage: widget.changeLanguage,
                  changeNotificationSound: widget.changeNotificationSound,
                  isDarkMode: widget.isDarkMode,
                  selectedNotificationSound: widget.selectedNotificationSound,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller,
      bool isEditing, VoidCallback onEdit,
      {bool isEmail = false}) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            readOnly: !isEditing,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
              suffixIcon: isEditing
                  ? IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        setState(() {
                          _isEditingFirstName = false;
                          _isEditingNickname = false;
                          _isEditingEmail = false;
                        });
                        _saveProfile();
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.edit, color: Colors.orange),
                      onPressed: onEdit,
                    ),
            ),
            validator: isEmail
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return "E-posta adresi boş olamaz";
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Geçerli bir e-posta adresi girin';
                    }
                    return null;
                  }
                : null,
          ),
        ),
      ],
    );
  }
}
