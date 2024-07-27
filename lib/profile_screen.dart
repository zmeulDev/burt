import 'package:burt/widgets/wave_clipper.dart';
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

  Future<void> _showMessage(String message, {Color color = Colors.green}) async {
    if (!mounted) return;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: color,
          content: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = FirebaseAuth.instance.currentUser;

    _nameController.text = user?.displayName ?? '';

    final bool isGoogleUser = user != null && authService.isGoogleUser(user);

    return Scaffold(
      body: _authMethod.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 22),
                  SvgPicture.asset(
                    'assets/illustrations/user_profile.svg',
                    height: 200,
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.email, color: Theme.of(context).colorScheme.onSurface),
                            SizedBox(width: 8.0),
                            Text(
                              user?.email ?? 'N/A',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(Icons.security, color: Theme.of(context).colorScheme.onSurface),
                            SizedBox(width: 8.0),
                            Text(
                              _authMethod.capitalize(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      children: [
                        if (isGoogleUser)
                          Text(
                            'Name: ${user?.displayName ?? 'N/A'}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        if (!isGoogleUser)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        if (!isGoogleUser)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'New Password',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.lock),
                              ),
                              obscureText: true,
                            ),
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
                              prefixIcon: Icon(Icons.palette),
                            ),
                            items: AppTheme.values.map((AppTheme theme) {
                              return DropdownMenuItem(
                                value: theme,
                                child: Text(theme.toString().split('.').last),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.save_outlined),
                        onPressed: () async {
                          bool updateSuccess = true;
                          try {
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
                          } catch (e) {
                            updateSuccess = false;
                          }
                          _showMessage(updateSuccess ? 'Profile updated successfully' : 'Failed to update profile',
                              color: updateSuccess ? Colors.green : Colors.red);
                        },
                        tooltip: 'Update Profile',
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outlined),
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
                              _showMessage('Account and data deleted successfully');
                            }
                          }
                        },
                        tooltip: 'Delete Account',
                        color: Colors.red, // Set the icon color to red for the delete button
                      ),
                      IconButton(
                        icon: Icon(Icons.logout_outlined),
                        onPressed: () {
                          authService.signOut();
                        },
                        tooltip: 'Log Out',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
