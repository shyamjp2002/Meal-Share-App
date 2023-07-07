import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';
import './admin_appbar.dart';
import './admin_inmates.dart';

class AdminHomePage extends StatefulWidget {

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  String? _userUid;
  String? _hostelName;
  int? _inmatesCount;

 @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getData() async{
     _userUid = FirebaseAuth.instance.currentUser!.uid;
    try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('hostel_admins')
        .where('uid', isEqualTo: _userUid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      
        _hostelName = data['hostel'];
        print(_hostelName);
      
      QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
        .collection('users')
        .where('hostel', isEqualTo: _hostelName)
        .limit(1)
        .get();
        if(querySnapshot1.docs.isNotEmpty){
          setState(() {
        _inmatesCount = querySnapshot1.docs.length;
      });
        print(_inmatesCount);
        }

      
      // Access the fields using the data variable
       
      // Store the data in a variable or do any other processing
      print('Inmates Count: $_inmatesCount');
    } else {
      print('Document not found');
    }
  } catch (error) {
    print('Error: $error');
  }
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
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AdminAppBar
        (),
        backgroundColor: Color(0xFF1D1F24),
        body: Stack(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1.0),
                  color: Color(0xFF1D1F24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(

                      DateFormat('EEEE').format(DateTime.now()),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      DateFormat('MMM d').format(DateTime.now()),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1.0),
                      color: Color(0xFF1D1F24),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_inmatesCount',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        Text(
                          'Inmates',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: 300, // Same width as the rectangle above
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminInmates(),
                          ),
                        );
                      },
                      child: Text(
                        'Inmates',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF449183),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: IconButton(
                  onPressed: () {
                    // TODO: Add button functionality
                  },
                  icon: Icon(Icons.qr_code_scanner),
                  iconSize: 40,
                  color: Color(0xFF449183),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
