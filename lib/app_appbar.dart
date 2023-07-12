import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import './profile.dart';
 // Replace with the actual path to your Messcut widget


import './mess_cut.dart';
import './login_page.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double appBarHeight = 56.0;
  

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Essen'),
      backgroundColor: Color(0xFF449183),
      actions: [
        IconButton(
          onPressed: ()  {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          icon: Icon(Icons.person),
        ),
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
