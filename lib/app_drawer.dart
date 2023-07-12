import 'package:flutter/material.dart';
import './mess_cut.dart';
import './login_page.dart';
import './welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './share_meal.dart';
import './shared_slots.dart';
import './view_messcuts.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF449183),
            ),
            child: Text(
              'Essen',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
                    ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Handle Home tile tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()), // Navigate to Messcut widget
              ); // Close the drawer
              // Add your code here for the Home functionality
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            
            title: Text('Add Mess Cut'),
            onTap: () {
              // Handle Add Mess tile tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Messcut()), // Navigate to Messcut widget
              ); // Close the drawer
              // Add your code here for the Add Mess functionality
            },
          ),
          ListTile(
  leading: Icon(Icons.share_outlined), // Change the icon to share meals icon
  title: Text('Share Meal'),
  onTap: () {
    // Handle Share Meal tile tap
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShareMeal()), // Navigate to ShareMeal widget
    ); // Close the drawer
    // Add your code here for the Share Meal functionality
  },
),

          ListTile(
            leading: Icon(Icons.settings_backup_restore_rounded),
            title: Text('View Shared Meals'),
            onTap: () {
              // Handle Share Meal tile tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SharedMeal()), // Navigate to Messcut widget
              ); // Close the drawer
              // Add your code here for the Share Meal functionality
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_backup_restore_rounded),
            title: Text('View Mess Cuts'),
            onTap: () {
              // Handle Share Meal tile tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewMessCut()), // Navigate to Messcut widget
              ); // Close the drawer
              // Add your code here for the Share Meal functionality
            },
          ),
          
        ],
      ),
    );
  }
}
