import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import './app_appbar.dart';
// import './app_drawer.dart';

void main() {
  runApp(ViewMessCut());
}

class ViewMessCut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Share',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MealShareHomePage(),
    );
  }
}

class MealShareHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mess Cut'),
        backgroundColor: const Color(0xFF449183),
      ),
      backgroundColor: const Color(0xFF1D1F24),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('mess_cuts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final messCuts = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                for (int slNo = 1; slNo <= messCuts.length; slNo++)
                  Column(
                    children: [
                      Container(
                        width: 400,
                        height: 120,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              child: Center(
                                child: Text(
                                  slNo.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 0, 0, 0),
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
                                    'From: ${messCuts[slNo - 1]['from']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'To: ${messCuts[slNo - 1]['to']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.restaurant,
                              size: 100,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10), // Add space between containers
                    ],
                  ),
                  const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
