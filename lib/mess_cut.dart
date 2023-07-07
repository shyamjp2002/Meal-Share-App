import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'firebase_options.dart';
import 'app_drawer.dart';
import 'app_appbar.dart';

class Messcut extends StatefulWidget {
  const Messcut({Key? key});

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Messcut> {
  String? userUid;
  String? documentId;
  String? hostelName;
  String? userName;
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  String? selectedStartDate;
  String? selectedEndDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserUid();
  }

  Future<void> getUserUid() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userUid = user.uid;
        _isLoading = false;
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (pickedStartDate != null) {
      final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
      final String formattedDate = dateFormatter.format(pickedStartDate);

      setState(() {
        _startDateController.text = formattedDate;
        selectedStartDate = formattedDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedEndDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (pickedEndDate != null) {
      final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
      final String formattedDate = dateFormatter.format(pickedEndDate);

      setState(() {
        _endDateController.text = formattedDate;
        selectedEndDate = formattedDate;
      });
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D1F24),
      appBar: AppAppBar(),
      drawer: AppDrawer(),
      body: Stack(
        children: [
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Container(
                        height: 250,
                        width: 250,
                        padding: EdgeInsets.all(30),
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 17, 138, 21),
                          border: Border.all(color: Colors.yellow, width: 5),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(5, 5),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Start Date:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            InkWell(
                              onTap: () =>_selectStartDate(context),
                              child: IgnorePointer(
                                child: TextField(
                                  controller: _startDateController,
                                  decoration: InputDecoration(
                                    hintText: 'Select start date',
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'End Date:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            InkWell(
                              onTap: () => _selectEndDate(context),
                              child: IgnorePointer(
                                child: TextField(
                                  controller: _endDateController,
                                  decoration: InputDecoration(
                                    hintText: 'Select end date',
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 100),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });

                          String mess_cut_id = Uuid().v4();
                          QuerySnapshot snapshot =
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .where('uid', isEqualTo: userUid)
                                  .get();
                          documentId = snapshot.docs[0].id;

                          DocumentReference? userDocRef =
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(documentId!);
                          DocumentSnapshot docSnapshot =
                              await userDocRef!.get();
                          hostelName = docSnapshot.get('hostel');
                          userName = docSnapshot.get('name');

                          Map<String, String> dataToSave = {
                            'from': selectedStartDate!,
                            'to': selectedEndDate!,
                            'uid': userUid!,
                            'hostel': hostelName!,
                            'name': userName!,
                            'mess_cut_id': mess_cut_id,
                          };

                          await FirebaseFirestore.instance
                              .collection('mess_cuts')
                              .add(dataToSave);

                          setState(() {
                            _isLoading = false;
                          });
                        },
                        child: Text('SUBMIT'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          textStyle: TextStyle(fontSize: 16),
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 4,
                        ),
                      ),
                      SizedBox(height: 50),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                      SizedBox(height: 50),
                      Text(
                        'Additional Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
