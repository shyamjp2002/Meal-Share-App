import 'package:flutter/material.dart';



class AdminInmates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Share',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: InmatePage(),
    );
  }
}

class InmatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('INMATES'),
        backgroundColor: Color(0xFF449183),
      ),
      backgroundColor: Color(0xFF1D1F24), // Set the page background color
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 360,
              height: 100,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                              'https://media.licdn.com/dms/image/D5603AQGlvWWEKLsfDA/profile-displayphoto-shrink_800_800/0/1671468305752?e=1694044800&v=beta&t=YlNEsmiCoP4goNW6ekg7eJ_HYgqUhO3QFngPZQy0x84'),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Gouri',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          'Mess Id: 1025',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'Course: B.tech',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Phone: 987654321 ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 100,
                    height: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '20',
                                    style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Bill Pending',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Perform edit action
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      primary: Color(0xFF449183),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(2),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Add any additional widgets or content below
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Perform add action
        },
        child: Icon(Icons.add, color: Colors.black),
        backgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}