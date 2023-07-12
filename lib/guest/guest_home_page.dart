// import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import './view_slots.dart';
// import './bottom_nav_bar.dart';
// import './guest_appbar.dart';

// class GuestHomePage extends StatefulWidget {
//   @override
//   State<GuestHomePage> createState() => _GuestHomePageState();
// }

// class _GuestHomePageState extends State<GuestHomePage> {
//   int _selectedTabIndex = 0;  
//   void _onTabSelected(int index) {
//     setState(() {
//       _selectedTabIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         bottomNavigationBar: CustomBottomNavigationBar(onTabSelected: _onTabSelected),
//         appBar: GuestAppBar(title: 'Home Page'),
//         body: Stack(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(40.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.8),
//                     blurRadius: 50,
//                     offset: const Offset(2, 2),
//                   ),
//                 ],
//               ),
//               margin: EdgeInsets.all(15),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(40.0),
//                 child: Image.network(
//                   'https://img.freepik.com/free-photo/top-view-meals-tasty-yummy-different-pastries-dishes-brown-surface_140725-14554.jpg?size=626&ext=jpg&ga=GA1.2.819674370.1688843495&semt=sph',
//                 ),
//               ),
//             ),
//             Container(
//               width: double.infinity,
//               height: double.infinity,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.white.withOpacity(0),
//                     Colors.white.withOpacity(0)
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 40),
//                 child: Container(
//                   width: 200.0,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => SharedMealGuest(),
//                         ),
//                       );
//                       print('Button clicked!');
//                     },
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 16.0),
//                       backgroundColor: const Color(0xFF449183),
//                       elevation: 4.0,
//                       shadowColor: const Color.fromARGB(255, 4, 3, 3),
//                     ),
//                     child: const Text(
//                       'Slots',
//                       style: TextStyle(fontSize: 18.0),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.center,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 330),
//                   Text(
//                     "Welcome " + FirebaseAuth.instance.currentUser!.displayName.toString(),
//                     style: const TextStyle(
//                       fontSize: 40,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF449183),
//                       shadows: [
//                         Shadow(
//                           color: Color.fromRGBO(255, 255, 255, 1),
//                           blurRadius: 5,
//                           offset: Offset(1, 1),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // const SizedBox(height: 70),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './view_slots.dart';
import './bottom_nav_bar.dart';
import './guest_appbar.dart';

class GuestHomePage extends StatefulWidget {
  @override
  State<GuestHomePage> createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> {
  int _selectedTabIndex = 0;
  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: _selectedTabIndex, onTabSelected: _onTabSelected),
      appBar: GuestAppBar(title: 'Home Page'),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.8),
                  blurRadius: 50,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            margin: const EdgeInsets.all(15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: Image.network(
                'https://img.freepik.com/free-photo/top-view-meals-tasty-yummy-different-pastries-dishes-brown-surface_140725-14554.jpg?size=626&ext=jpg&ga=GA1.2.819674370.1688843495&semt=sph',
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0),
                  Colors.white.withOpacity(0)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Container(
                width: 200.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SharedMealGuest(),
                      ),
                    );
                    print('Button clicked!');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: const Color(0xFF449183),
                    elevation: 4.0,
                    shadowColor: const Color.fromARGB(255, 4, 3, 3),
                  ),
                  child: const Text(
                    'Slots',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 330),
                Text(
                  "Welcome " + FirebaseAuth.instance.currentUser!.displayName.toString(),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF449183),
                    shadows: [
                      Shadow(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 70),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
