import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './app_appbar.dart';
import './app_drawer.dart';
import './share_meal.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userName = FirebaseAuth.instance.currentUser!.displayName;
  String? _userUid = FirebaseAuth.instance.currentUser!.uid;
  int? mess_id;
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
          .where('uid', isEqualTo: _userUid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          userName = data['name'];
          mess_id = data['mess_id'];
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
      appBar: AppAppBar(),
      drawer: AppDrawer(),
      backgroundColor: Color(0xFF1D1F24),
      body: Align(
        alignment: Alignment.center,
        child: isLoading
            ? CircularProgressIndicator()
            : Container(
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
                            'Mess NO. :' + mess_id.toString()!,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 75.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                     padding: EdgeInsets.all(16.0),
                      child: QrImageView(
                        data: _userUid.toString(),
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ShareMeal()),
                        );
                        print('Share Meal pressed');
                      },
                      child: Text(
                        'Share Meal',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(200.0, 50.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
