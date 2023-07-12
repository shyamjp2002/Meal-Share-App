import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './guest_appbar.dart';
import './slot_details.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ConfirmSlotPage extends StatefulWidget {
  final String mealId;

  ConfirmSlotPage({required this.mealId});

  @override
  State<ConfirmSlotPage> createState() => _ConfirmSlotPageState();
}

class _ConfirmSlotPageState extends State<ConfirmSlotPage> {
  @override
  void initState() {
    super.initState();
  }

  void updateSlotStatus(String mealId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Share_meal_slots')
          .where('meal_id', isEqualTo: mealId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;

        await FirebaseFirestore.instance
            .collection('Share_meal_slots')
            .doc(documentId)
            .update({
          'status': 'Sold',
          'guest_uid': FirebaseAuth.instance.currentUser!.uid,
          'isCompleted': 'No',
        });

        print('Slot updated successfully');
      } else {
        print('No matching document found');
      }
    } catch (error) {
      print('Error updating slot: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Share_meal_slots')
          .where('meal_id', isEqualTo: widget.mealId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final documents = snapshot.data!.docs;
          if (documents.isNotEmpty) {
            final document = documents.first;
            final data = document.data() as Map<String, dynamic>;
            final hostel = data['hostel'];
            final issueDate = data['Date'];
            final status = data['status'];

            return Scaffold(
              appBar: GuestAppBar(title: 'Confirm Slot'),
              body: Stack(
                children: [
                  Container(
                    color: const Color(0xFF449183),
                    child: Center(
                      child: ElevatedCard(
                        hostel: hostel,
                        issueDate: issueDate,
                        status: status,
                        mealId: widget.mealId,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 60,
                      ),
                      color: const Color(0xFF449183),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              print('Go Back button pressed');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Go Back',
                              style: TextStyle(
                                color: Color(0xFF449183),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Razorpay _razorpay = Razorpay();

                              var options = {
                                'key': 'rzp_test_NFTzY8U2i63OGJ',
                                'amount':
                                    3500, //in the smallest currency sub-unit.
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

                              updateSlotStatus(
                                widget.mealId,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SlotDetails(
                                    mealId: widget.mealId,
                                    mess: data['hostel'],
                                    date: data['Date'],
                                    meal: data['Meal'],
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF449183),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                            child: const Text('Confirm'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Text('No data found'),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error fetching data'),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    
    updateSlotStatus(widget.mealId,);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    updateSlotStatus(widget.mealId,);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    updateSlotStatus(widget.mealId,);
  }

  void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class ElevatedCard extends StatelessWidget {
  final String hostel;
  final String issueDate;
  final String status;
  final String mealId;

  ElevatedCard({
    Key? key,
    required this.hostel,
    required this.issueDate,
    required this.status,
    required this.mealId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.translate(
        offset: const Offset(0, -90),
        child: Card(
          child: SizedBox(
            width: 340,
            height: 180,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    './assets/lun.png',
                    width: 80,
                    height: 80,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Issue date:'),
                      Text(
                        issueDate,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text('Mess:'),
                      Text(
                        hostel,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text('Status:'),
                      Text(
                        status,
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'ID:#' + mealId,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '₹ 15',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    './assets/lunch.jpeg',
                    width: 80,
                    height: 80,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
