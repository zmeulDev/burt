import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _message = '';
  String _authMethod = '';

  @override
  void initState() {
    super.initState();
    _fetchAuthMethod();
  }

  void _fetchAuthMethod() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        if (mounted) {
          setState(() {
            _authMethod = doc['authMethod'] ?? 'Unknown';
            _phoneController.text = doc['phoneNumber'] ?? '';
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = FirebaseAuth.instance.currentUser;

    _nameController.text = user?.displayName ?? '';

    final bool isGoogleUser = user != null && authService.isGoogleUser(user);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authService.signOut();
            },
            tooltip: 'Log Out',
          ),
        ],
      ),
      body: _authMethod.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/illustrations/user_profile.svg',
                height: 200,
              ),
              SizedBox(height: 16),
              Text(
                'Email: ${user?.email ?? 'N/A'}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'Authentication Method: ${_authMethod.capitalize()}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (isGoogleUser) ...[
                Text(
                  'Name: ${user?.displayName ?? 'N/A'}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              if (!isGoogleUser) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final name = _nameController.text.trim();
                      final password = _passwordController.text.trim();
                      final phoneNumber = _phoneController.text.trim();
                      if (!isGoogleUser && name.isNotEmpty) {
                        await authService.updateUserName(name);
                      }
                      if (!isGoogleUser && password.isNotEmpty) {
                        await authService.updatePassword(password);
                      }
                      if (phoneNumber.isNotEmpty) {
                        await authService.updatePhoneNumber(phoneNumber);
                      }
                      if (mounted) {
                        setState(() {
                          _message = 'Profile updated successfully';
                        });
                      }
                    },
                    icon: Icon(Icons.update),
                    label: Text('Update Profile'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      bool? confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Delete Account'),
                          content: Text('Are you sure you want to delete your account? All data will be erased.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await authService.deleteUser();
                        if (mounted) {
                          setState(() {
                            _message = 'Account and data deleted successfully';
                          });
                        }
                      }
                    },
                    icon: Icon(Icons.delete),
                    label: Text('Delete Account'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Set the background color to red for the delete button
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: DropdownButtonFormField<AppTheme>(
                  value: authService.currentTheme,
                  onChanged: (AppTheme? newTheme) {
                    if (newTheme != null) {
                      authService.setTheme(newTheme);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Theme',
                    border: OutlineInputBorder(),
                  ),
                  items: AppTheme.values.map((AppTheme theme) {
                    return DropdownMenuItem(
                      value: theme,
                      child: Text(theme.toString().split('.').last),
                    );
                  }).toList(),
                ),
              ),
              if (_message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _message,
                    style: TextStyle(color: Colors.green),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
