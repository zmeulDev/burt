import 'package:burt/widgets/wave_clipper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'auth_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              padding: const EdgeInsets.only(bottom: 450),
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              height: 270,
              alignment: Alignment.center,

            ),
          ),
          ClipPath(
            clipper: WaveClipper(waveDeep: 0, waveDeep2: 100 ),
            child: Container(
              padding: const EdgeInsets.only(bottom: 50),
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
              height: 220,
              alignment: Alignment.center,

            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 150),
                  SvgPicture.asset(
                    'assets/illustrations/account_creation.svg',
                    height: 200,
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'burt',
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),

                  Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.password_rounded),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        obscureText: true,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();
                      if (email.isNotEmpty && password.isNotEmpty) {
                        if (mounted) {
                          setState(() {
                            _message = _isSignUp ? 'Creating account...' : 'Signing in...';
                          });
                        }
                        try {
                          final user = _isSignUp
                              ? await authService.createUserWithEmail(email, password)
                              : await authService.signInWithEmail(email, password);
                          if (mounted) {
                            setState(() {
                              _message = _isSignUp
                                  ? 'Account created successfully!'
                                  : 'Successfully signed in!';
                            });
                          }
                        } on FirebaseAuthException catch (e) {
                          if (mounted) {
                            setState(() {
                              _message = e.message!;
                            });
                          }
                        }
                      } else {
                        if (mounted) {
                          setState(() {
                            _message = 'Please enter both email and password.';
                          });
                        }
                      }
                    },
                    child: Text(_isSignUp ? 'Create Account' : 'Sign In with Email'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (mounted) {
                        setState(() {
                          _isSignUp = !_isSignUp;
                          _message = '';
                        });
                      }
                    },
                    child: Text(_isSignUp
                        ? 'Already have an account? Sign in'
                        : 'Don\'t have an account? Sign up'),
                  ),
                  if (_message.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _message,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  SizedBox(height: 16),
                  Text('Or sign in with'),
                  IconButton(
                    onPressed: () async {
                      await authService.signInWithGoogle();
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/google_icon.svg',
                      height: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

      ),
    );
  }
}


