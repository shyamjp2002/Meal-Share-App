// import 'package:flutter/material.dart';
// import './guest_home_page.dart';
// import './view_slots.dart';
// import './owned_slots.dart';

// class CustomBottomNavigationBar extends StatefulWidget {
//   final ValueChanged<int> onTabSelected;

//   const CustomBottomNavigationBar({required this.onTabSelected});

//   @override
//   _CustomBottomNavigationBarState createState() =>
//       _CustomBottomNavigationBarState();
// }

// class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     widget.onTabSelected(index);
//     if (index == 0) {
//       // Navigate to the desired page when "Home" is selected
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => GuestHomePage()),
//       );
//     }

//     else if (index == 1) {
//       // Navigate to the desired page when "Home" is selected
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => SharedMealGuest()),
//       );
//     }
//     else if (index == 2) {
//       // Navigate to the desired page when "Home" is selected
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => OwnedMealGuest()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       items: const <BottomNavigationBarItem>[
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           label: 'Home',
          
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.airplane_ticket),
//           label: 'Slot',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.settings_backup_restore_rounded),
//           label: 'Booked',
//         ),
//         ],
//       currentIndex: _selectedIndex,
//       unselectedItemColor: Colors.black,
//       selectedItemColor: const Color(0xFF449183),
//       onTap: _onItemTapped,
//     );
//   }
// }


import 'package:flutter/material.dart';
import './guest_home_page.dart';
import './view_slots.dart';
import './owned_slots.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const CustomBottomNavigationBar({required this.selectedIndex,required this.onTabSelected});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    widget.onTabSelected(index);
    if (index == 0) {
      // Navigate to the desired page when "Home" is selected
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GuestHomePage()),
      );
    } else if (index == 1) {
      // Navigate to the desired page when "Slot" is selected
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SharedMealGuest()),
      );
    } else if (index == 2) {
      // Navigate to the desired page when "Booked" is selected
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OwnedMealGuest()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.airplane_ticket),
          label: 'Slot',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_backup_restore_rounded),
          label: 'Booked',
        ),
      ],
      currentIndex: _selectedIndex,
      unselectedItemColor: Colors.black,
      selectedItemColor: const Color(0xFF449183),
      onTap: _onItemTapped,
    );
  }
}
