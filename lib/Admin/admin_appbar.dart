import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../firebase_options.dart';
import './admin_login.dart';

 // Replace with the actual path to your Messcut widget




class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double appBarHeight = 56.0;
  

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('MealShare App'),
      backgroundColor: Color(0xFF449183),
      actions: [
        IconButton(
          onPressed: () async {
            await GoogleSignIn().signOut();
            FirebaseAuth.instance.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminLoginPage()),
            );
          },
          icon: Icon(Icons.logout_rounded),
        ),
        
      ],
    );
  }
}
