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

  late UserModel _userModel;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          _userModel = UserModel.fromMap(doc.data() as Map<String, dynamic>, user.uid);
          _nameController.text = _userModel.name;
        });
      }
    }
  }

  Future<void> _updateUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      _userModel = UserModel(uid: user.uid, name: _nameController.text, email: user.email!);
      await _firestore.collection('users').doc(user.uid).set(_userModel.toMap());
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              LineIcons.user,
              size: 100,
              color: Colors.grey,
            ),
            CustomTextField(controller: _nameController, label: 'Name'),
            TextFormField(
              initialValue: _auth.currentUser?.email,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              readOnly: true,
            ),
            CustomButton(text: 'Save', onPressed: _updateUserProfile),
          ],
        ),
      ),
    );
  }
}
