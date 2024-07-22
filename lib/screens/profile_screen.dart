import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../models/user_model.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import '../theme_notifier.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _userModel;
  final TextEditingController _nicknameController = TextEditingController();
  String _selectedTheme = 'Light';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          setState(() {
            _userModel = UserModel.fromMap(doc.data() as Map<String, dynamic>, user.uid);
            _nicknameController.text = _userModel!.nickname ?? "";
          });
        }
      } catch (e) {
        print("Error loading user data: $e");
      }
    }
  }

  Future<void> _updateUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      _userModel = UserModel(
        uid: user.uid,
        nickname: _nicknameController.text,
      );
      await _firestore.collection('users').doc(user.uid).set(_userModel!.toMap());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(LineIcons.alternateSignOut),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              LineIcons.user,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 24),
            if (_auth.currentUser != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Google Auth Data:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Name: ${_auth.currentUser!.displayName ?? "N/A"}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Email: ${_auth.currentUser!.email ?? "N/A"}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            SizedBox(height: 24),
            CustomTextField(
              controller: _nicknameController,
              label: 'Nickname',
              prefixIcon: Icon(LineIcons.user, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _selectedTheme,
              items: <String>['Light', 'Dark', 'Light High Contrast', 'Dark High Contrast'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedTheme = newValue;
                    themeNotifier.setTheme(ThemeNotifier.getThemeByName(newValue));
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Select Theme',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
            ),
            SizedBox(height: 24),
            CustomButton(text: 'Save', onPressed: _updateUserProfile),
          ],
        ),
      ),
    );
  }
}
