import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './admin_home_page.dart';


class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _passwordErrorText = '';

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  String _validatePassword(String value) {
    // Password criteria: At least 8 characters long, contains uppercase and lowercase letters, and at least one digit
    if (value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    } else if (!value.contains(RegExp(r'[A-Z]')) ||
        !value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain both uppercase and lowercase letters';
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one digit';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Admin Login'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20.0),
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter the email',
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter the password',
                      errorText: _passwordErrorText.isNotEmpty
                          ? _passwordErrorText
                          : null,
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        _passwordErrorText = _validatePassword(value);
                      });
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    _loginWithEmailAndPassword(context);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                  ),
                  child: Text('LOGIN'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _loginWithEmailAndPassword(BuildContext context) async {
  final String email = _emailController.text;
  final String password = _passwordController.text;

  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Authentication successful, navigate to the next screen or perform other actions
    // For example, you can show a success message and navigate to a home screen
    print('Authentication successful');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminHomePage()),
    );
  } catch (e) {
    // Authentication failed, display an error message
    print('Authentication failed: $e');
    setState(() {
      _passwordErrorText = 'Invalid username or password';
    });
  }
}
}
