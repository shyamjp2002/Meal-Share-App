import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './admin_inmates.dart';

void main() {
  runApp(AddInmate());
}

class AddInmate extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  String? hostelName;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20.0),
            color: Color(0xFF1D1F24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add Inmate',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFADD8E6),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter the name',
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFADD8E6),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter the Email',
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFADD8E6),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: TextField(
                    controller: mobileController,
                    decoration: InputDecoration(
                      hintText: 'Enter the Mobile number',
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFADD8E6),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: TextField(
                    controller: courseController,
                    decoration: InputDecoration(
                      hintText: 'Enter the Course name',
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFADD8E6),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: TextField(
                    controller: departmentController,
                    decoration: InputDecoration(
                      hintText: 'Enter the department name',
                    ),
                  ),
                ),
                SizedBox(height: 20.0), // Added SizedBox for spacing
                ElevatedButton(
                  onPressed: () {
                    // Call the function to create the document
                    createDocument(context);
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> fetchHostelName() async {
    try {
      // Get the current user's UID
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // Access the Firestore instance
      final firestore = FirebaseFirestore.instance;

      // Fetch the hostel name based on the UID
      final snapshot = await firestore
          .collection('hostel_admins')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      // Check if any documents match the query
      if (snapshot.docs.isNotEmpty) {
        // Retrieve the first document and extract the hostel name
         hostelName = snapshot.docs[0].data()['hostel'];

        // Store the hostel name in a variable or use it as desired
        print('Hostel Name: $hostelName');
      } else {
        print('No matching documents found');
      }
    } catch (error) {
      print('Error fetching hostel name: $error');
    }
  }

  Future <void> createDocument(BuildContext context) async{


    // Access the Firestore instance
    final firestore = FirebaseFirestore.instance;

    // Fetch the values from the text fields
    final String name = nameController.text;
    final String email = emailController.text;
    final String mobile = mobileController.text;
    final String course = courseController.text;
    final String department = departmentController.text;
      final QuerySnapshot snapshot1 = await FirebaseFirestore.instance.collection('users').get();
    final documentCount = snapshot1.size + 1;
    
    await fetchHostelName();
     
    // Add a new document to the "users" collection
    firestore.collection('users').add({
      'name': name,
      'email': email,
      'Mobile': mobile,
      'Course': course,
      'Department': department,
      'mess_id': documentCount,
      'hostel': hostelName,
      'Pending': '0',

    }).then((value) {
      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminInmates(),
                      ),
                    );
      print('Document created successfully!');
    }).catchError((error) {
      // Error handling
      print('Error creating document: $error');
    });
  }
}
