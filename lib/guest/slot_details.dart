import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './owned_slots.dart';


class SlotDetails extends StatefulWidget {
  final String mealId;
  final String mess;
  final String meal;
  final String date;

  SlotDetails({required this.mess, required this.meal, required this.date, required this.mealId});

  @override
  State<SlotDetails> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<SlotDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF449183),
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: QrImageView(
                        data: widget.mealId.toString(),
                        version: QrVersions.auto,
                        size: 250.0,
                        
                      ),
                    ),
                    // Add spacing between the QR code container and the dotted line
                    Container(
                      height: 1.0,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 80.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(2.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.4),
                            blurRadius: 1.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                    ),
                    // Add spacing between the dotted line and the information container
                    Container(
                      width: 280.0,
                      height: 130.0,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Color.fromARGB(255, 209, 248, 238),
                      ),
                      child: Column(
                        children: [
                          Text(
                            FirebaseAuth.instance.currentUser!.displayName!.toString(),
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Mess: ${widget.mess}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Meal: ${widget.meal}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Date: ${widget.date}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(bottom: 16.0),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OwnedMealGuest(),
                    ),
                  );
                  print('Back button pressed');
                },
                icon: Icon(
                  Icons.arrow_back,
                  color:
                      Colors.white, // Set the color of the back icon to white
                ),
                label: Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(200.0, 50.0),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color(0xFF449183),
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

