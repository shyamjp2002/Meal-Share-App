import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import './login_page.dart';
import './welcome_page.dart';
import '/app_drawer.dart';
import './guest/guest_home_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

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
      title: 'Essen',
      debugShowCheckedModeBanner: false,
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
            signInWithGoogle(context);
          }
          }
          return Center(child: CircularProgressIndicator());
        }


      ),
      
    );
  }
  Future<void> signInWithGoogle(BuildContext context) async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    User? user = FirebaseAuth.instance.currentUser;
    String? email = user!.email;
    String? uid = user.uid;
    String? userName = FirebaseAuth.instance.currentUser!.displayName;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        DocumentReference documentRef = documentSnapshot.reference;
        print(documentSnapshot.data());

        // Update the document by adding a new field
        documentRef.set(
          {'uid': uid},
          SetOptions(merge: true),
        ).then((value) {
          print('Document updated successfully and logged in as inmate.');
        }).catchError((error) {
          print('Error updating document: $error');
        });
        
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WelcomeScreen()), // Navigate to Messcut widget
        );
        print('Current user email: $email');
      } else {
        QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
            .collection('guest_users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();
        if (querySnapshot1.docs.isNotEmpty) {
          print('Current user email: $email');
          print('logged in as guest user');
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    GuestHomePage()), // Navigate to Messcut widget
          );
        }
        else{
          Map<String, String> dataToSave = {
          'uid': uid,
          'name': userName!,
          'email': email!,
        };
        await FirebaseFirestore.instance
            .collection('guest_users')
            .add(dataToSave);
            print("guest user registered successfully");
            Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    GuestHomePage()), // Navigate to Messcut widget
          );
        }
        
      }
    }

    print(userCredential.user?.displayName);
  }
}
