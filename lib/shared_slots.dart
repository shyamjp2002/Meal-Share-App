import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './app_appbar.dart';
import './app_drawer.dart';

class SharedMeal extends StatelessWidget {
  final CollectionReference shareMealCollection =
      FirebaseFirestore.instance.collection('Share_meal_slots');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Share',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<QuerySnapshot>(
        future: shareMealCollection.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('Data available!');
            List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            return MealShareHomePage(documents: documents);
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class MealShareHomePage extends StatelessWidget {
  final List<QueryDocumentSnapshot> documents;

  MealShareHomePage({required this.documents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(),
      drawer: AppDrawer(),
      backgroundColor: Color(0xFF1D1F24),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var document in documents)
                InkWell(
                  onTap: () {
                    // Handle container pressed
                    print('Container pressed!');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      width: 360,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            child: Center(
                              child: Text(
                                document['Meal'],
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF000000),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Issue date : ${document['Date']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Mess: ${document['hostel']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      'Status: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                    Text(
                                      document['status'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'ID: ${document['meal_id']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100,
                            height: double.infinity,
                            child: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/3480/3480823.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(SharedMeal());
}
