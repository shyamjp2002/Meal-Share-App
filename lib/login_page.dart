import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import './welcome_page.dart';
import './Admin/admin_login.dart';
import './guest/guest_home_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return Scaffold(
              body: FractionallySizedBox(
                // Added FractionallySizedBox
                widthFactor: 1.0, // Occupies full width of the screen
                heightFactor: 1.0, // Occupies full height of the screen
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/background_image.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                                onPressed: () {
                                  signInWithGoogle(context);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/google-logo.png',
                                      height: 24,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Sign in with Google',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminLoginPage()),
                            );
                          },
                          child: Text(
                            'Admin Login',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            signInWithGoogle(context);
          }
        }

        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
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
