import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_icons/line_icons.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../models/user_model.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _userModel;
  final TextEditingController _nicknameController = TextEditingController();

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
    User? user = _auth.currentUser;
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
            if (user != null)
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
                      'Name: ${user.displayName ?? "N/A"}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Email: ${user.email ?? "N/A"}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            SizedBox(height: 24),
            CustomTextField(controller: _nicknameController, label: 'Nickname'),
            SizedBox(height: 24),
            CustomButton(text: 'Save', onPressed: _updateUserProfile),
          ],
        ),
      ),
    );
  }
}
