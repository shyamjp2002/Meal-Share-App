import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './admin_appbar.dart';
import './admin_qr_scanner.dart';
import 'package:camera/camera.dart';

class ProfilePage extends StatefulWidget {
  final String uid; // New argument

  ProfilePage({required this.uid}); // Constructor with the uid argument

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String? userName = FirebaseAuth.instance.currentUser!.displayName;
  String? _userUid = FirebaseAuth.instance.currentUser!.uid;
  int? mess_id;
  String? Course;
  String? dept;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: widget.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          userName = data['name'];
          mess_id = data['mess_id'];
          Course = data['Course'];
          dept = data['Department'];
        });
        print('mess id: $mess_id');
      } else {
        print('Document not found');
      }
    } catch (error) {
      print('Error: $error');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userUid = user.uid;
      });
      getData();
    } else {
      // Handle case when user is null
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(),
      backgroundColor: Color(0xFF1D1F24),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 64.0,
                    backgroundImage: NetworkImage(
                      'https://media.licdn.com/dms/image/D5603AQGlvWWEKLsfDA/profile-displayphoto-shrink_400_400/0/1671468305752?e=1693440000&v=beta&t=zMVJsJ4LZh3DqOTU3iueZ_Ir3SqgStDjvLfyk_6RWpg',
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    width: 250.0,
                    height: 130.0,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.grey[300],
                    ),
                    child: Column(
                      children: [
                        Text(
                          userName!,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Mess Id: '+ mess_id.toString()!,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Course: '+ Course!.toString(),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Department: '+ dept!.toString(),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.0),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: TextButton(
                onPressed: ()async {
                  final cameras = await availableCameras();
                    final firstCamera = cameras.first;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRCodeScannerApp(camera: firstCamera),
                      ),
                    );
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Color(0xFF449183)),
                  side: MaterialStateProperty.all(
                    BorderSide(
                      color: Color(0xFF449183),
                      width: 2.0,
                    ),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(
                      Size(180.0, 48.0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.qr_code_scanner, size: 40),
                    SizedBox(width: 8.0),
                    Text(
                      'Next',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


