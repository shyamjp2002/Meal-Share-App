import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import './login_page.dart';
import './welcome_page.dart';
import '/app_drawer.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  




  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context,AsyncSnapshot snapshot){
          if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }

          if(snapshot.connectionState==ConnectionState.active){

            if(snapshot.data==null){
              return LoginPage();
          }
          else{
            return WelcomeScreen();
          }
          }
          return Center(child: CircularProgressIndicator());
        }
        

      ),
      
    );
  }
}





