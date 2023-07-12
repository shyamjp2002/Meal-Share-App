import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import './mess_cut.dart';
import 'app_drawer.dart';
import 'app_appbar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? userName = FirebaseAuth.instance.currentUser!.displayName;
  String? _pendingDues;
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
          SizedBox(height: 0),
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
              width: 300,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(449183),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 5),
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
                      Razorpay _razorpay = Razorpay();

                              var options = {
                                'key': 'rzp_test_NFTzY8U2i63OGJ',
                                'amount':
                                    int.parse(pending.toString()), //in the smallest currency sub-unit.
                                'name': 'essen',
                                'description': 'Meal slot Payment',
                                'timeout': 120, // in seconds
                                'prefill': {
                                  'contact': '9961967548',
                                  'email': 'shyamjp2002@gmail.com'
                                }
                              };
                              _razorpay.open(options);
                              _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                                  _handlePaymentSuccess);
                              _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                                  _handlePaymentError);
                              _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                                  _handleExternalWallet);
                               _razorpay.open(options);
                               
                               Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WelcomeScreen(),
                          ),
                        );
                    },
                    child: Text('Pay now'),style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                Size(250.0, 40.0),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 0, 0, 0),
                              ),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 100),
          Text(
            'Today',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 25,),
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
                SizedBox(height: 5,),
                Center(
                  child: Text(
                    formattedDay,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 146, 141, 141),
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
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    
    User? user = FirebaseAuth.instance.currentUser;
  String currentUid = user!.uid;

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  QuerySnapshot querySnapshot =
      await usersCollection.where('uid', isEqualTo: currentUid.toString()).limit(1).get();

  querySnapshot.docs.forEach((documentSnapshot) async {
    try {
      await usersCollection
          .doc(documentSnapshot.id)
          .update({'Pending': '0'});
      print('Field updated successfully for document: ${documentSnapshot.id}');
    } catch (e) {
      print('Error updating field for document ${documentSnapshot.id}: $e');
    }
  });
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    User? user = FirebaseAuth.instance.currentUser;
  String? currentUid = user!.uid;

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  QuerySnapshot querySnapshot =
      await usersCollection.where('uid', isEqualTo: currentUid.toString()).limit(1).get();

  querySnapshot.docs.forEach((documentSnapshot) async {
    try {
      await usersCollection
          .doc(documentSnapshot.id)
          .update({'Pending': '0'});
      print('Field updated successfully for document: ${documentSnapshot.id}');
    } catch (e) {
      print('Error updating field for document ${documentSnapshot.id}: $e');
    }
  });
  }

  void _handleExternalWallet(ExternalWalletResponse response) async {
    User? user = FirebaseAuth.instance.currentUser;
  String currentUid = user!.uid;

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  QuerySnapshot querySnapshot =
      await usersCollection.where('uid', isEqualTo: currentUid.toString()).limit(1).get();

  querySnapshot.docs.forEach((documentSnapshot) async {
    try {
      await usersCollection
          .doc(documentSnapshot.id)
          .update({'Pending': '0'});
      print('Field updated successfully for document: ${documentSnapshot.id}');
    } catch (e) {
      print('Error updating field for document ${documentSnapshot.id}: $e');
    }
  });
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
