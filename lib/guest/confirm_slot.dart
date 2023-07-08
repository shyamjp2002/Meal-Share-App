import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmSlotPage extends StatelessWidget {
  final String mealId;

   ConfirmSlotPage({required this.mealId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Share_meal_slots')
          .where('meal_id', isEqualTo: mealId)
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
              body: Stack(
                children: [
                  Container(
                    color: const Color(0xFF449183),
                    child:  Center(
                      child: ElevatedCard(hostel: hostel,
  issueDate: issueDate,
  status: status,
  mealId: mealId,),
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
                              // Go Back button functionality here
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
                              // Button functionality
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

