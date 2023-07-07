import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import 'package:uuid/uuid.dart';
import './app_appbar.dart';
import './app_drawer.dart';
import 'package:intl/intl.dart';

class ShareMeal extends StatefulWidget {
  const ShareMeal({Key? key}) : super(key: key);

  @override
  _ShareMealState createState() => _ShareMealState();
}

class _ShareMealState extends State<ShareMeal> {
  String? userUid;
  String? documentId;
  String? hostelName;
  String? userName;
  String? pendingDues;
  DateTime? selectedDate;
  List<String> selectedOptions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserUid();
    // Call a method to fetch the user name
  }

  Future<void> getUserUid() async {
    // Retrieve the authenticated user
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userUid = user.uid; // Assign the UID to the userUid variable
      });

      // Wait for setState() to complete before fetching hostel name
      await getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D1F24),
      appBar: AppAppBar(),
      drawer: AppDrawer(),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showDatePicker(context);
                    },
                    child: Container(
                      height: 100,
                      width: 200,
                      padding: EdgeInsets.all(30),
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        border: Border.all(color: Colors.black, width: 4),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(5, 5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Text(
                        selectedDate != null
                            ? selectedDate.toString()
                            : "Select Date",
                        style: TextStyle(fontSize: 25, color: Colors.yellow),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 180,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ToggleButton(
                        text: "Breakfast",
                        onPressed: () {
                          _toggleOption("Breakfast");
                        },
                        isSelected: selectedOptions.contains("Breakfast"),
                      ),
                      SizedBox(width: 20),
                      ToggleButton(
                        text: "Lunch",
                        onPressed: () {
                          _toggleOption("Lunch");
                        },
                        isSelected: selectedOptions.contains("Lunch"),
                      ),
                      SizedBox(width: 20),
                      ToggleButton(
                        text: "Dinner",
                        onPressed: () {
                          _toggleOption("Dinner");
                        },
                        isSelected: selectedOptions.contains("Dinner"),
                      ),
                    ],
                  ),
                  SizedBox(height: 75),
                  if (selectedOptions.isNotEmpty)
                    Text(
                      "Selected Options: ${selectedOptions.join(", ")}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _handleSubmit,
                          child: Text("Submit"),
                        ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
      final String formattedDate = dateFormatter.format(pickedDate);

      setState(() {
        selectedDate = dateFormatter.parse(formattedDate);
      });
    }
  }

  void _toggleOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  void _handleSubmit() async {
    setState(() {
      _isLoading = true;
    });

    Uuid uuid = Uuid();
    String meal_id = uuid.v4().substring(0, 7);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: userUid)
        .get();
    documentId = snapshot.docs[0].id;

    DocumentReference? userDocRef =
        FirebaseFirestore.instance.collection('users').doc(documentId!);
    DocumentSnapshot docSnapshot = await userDocRef!.get();
    hostelName = docSnapshot.get('hostel');
    userName = docSnapshot.get('name');
    DateTime now = DateTime.now();

    String issueDate = DateFormat('dd-MM-yy').format(now);

    Map<String, String> dataToSave = {
      'Date': DateFormat('dd-MM-yy').format(selectedDate!),
      'Meal': selectedOptions.join(", "),
      'uid': userUid!,
      'hostel': hostelName!,
      'name': userName!,
      'meal_id': meal_id,
      'issueDate': issueDate,
      'status': 'Active',
    };

    await FirebaseFirestore.instance
        .collection('Share_meal_slots')
        .add(dataToSave);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: userUid)
        .get();
    if (snapshot.docs.isNotEmpty) {
      documentId = snapshot.docs[0].id;
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(documentId!);
      DocumentSnapshot docSnapshot = await userDocRef.get();
      if (docSnapshot.exists) {
        hostelName = docSnapshot.get('hostel');
        userName = docSnapshot.get('name');
        pendingDues = docSnapshot.get('Pending');
        print(hostelName);
        print(userName);
        print(pendingDues);
      } else {
        print("docsnapshot does not exist");
      }
    } else {
      print('No data found');
    }
  }
}

class ToggleButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSelected;

  const ToggleButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.isSelected,
  }) : super(key: key);

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:widget.onPressed,
      style: ElevatedButton.styleFrom(
        primary: widget.isSelected ? Colors.blue : Colors.grey,
      ),
      child: Text(widget.text),
    );
  }
}


