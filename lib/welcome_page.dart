import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import './mess_cut.dart';
import 'app_drawer.dart';
import 'app_appbar.dart';


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? userName = FirebaseAuth.instance.currentUser!.displayName;
  int? _pendingDues;
  String? pending;
  String? _documentId;
  String? _userUid = FirebaseAuth.instance.currentUser!.uid;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

void getData() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: _userUid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _pendingDues = data['Pending'];
       pending = _pendingDues.toString();
       _isLoading = false;

      });
      // Access the fields using the data variable
       
      // Store the data in a variable or do any other processing
      print('Pending: $pending');
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
        userName = user.displayName;
        _userUid = user.uid;
      });
       getData();
    } else {
      // Handle case when user is null
    }
  }

  



  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDay = DateFormat('EEEE').format(now);
    String formattedDate = DateFormat('dd MMM').format(now);

    return Scaffold(
      backgroundColor: Color(0xFF1D1F24),
      appBar: AppAppBar(),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'Hi $userName',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF1D1F24),
              border: Border.all(
                color: Colors.white,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: 200,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(449183),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Text(
                    '₹ $pending',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Pending amount',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Add your logic for payment processing here
                    },
                    child: Text('Pay now'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Today',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Center(
                  child: Text(
                    formattedDay,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Center(
                  child: Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MealCard(
                title: 'Breakfast',
                subtitle: 'Idli and sambar',
              ),
              MealCard(
                title: 'Lunch',
                subtitle: 'Meals and chicken fry',
              ),
              MealCard(
                title: 'Dinner',
                subtitle: 'Porotta and chicken curry',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const MealCard({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFF449183),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
