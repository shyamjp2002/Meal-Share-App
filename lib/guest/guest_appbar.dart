import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../firebase_options.dart';
import '../login_page.dart';

 // Replace with the actual path to your Messcut widget




class GuestAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double appBarHeight = 56.0;
  final String title;

  GuestAppBar({required this.title});
  

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Color(0xFF449183),
      actions: [
        IconButton(
          onPressed: () async {
            await GoogleSignIn().signOut();
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          icon: Icon(Icons.logout_rounded),
        ),
        
      ],
    );
  }
}
