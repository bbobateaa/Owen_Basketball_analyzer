import 'package:basketball_project_owen_wang/Login_page.dart';
import 'package:basketball_project_owen_wang/analyze/record/UploadVideo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'History.dart';
import 'Upload.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  int currentPageIndex = 2;
  User? _user = FirebaseAuth.instance.currentUser;

  void signOut() async{
    await FirebaseAuth.instance.signOut();
    _user = null;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Login_page()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => History()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Upload()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Setting()),
              );
              break;
          }
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
        body: Center(
        child: Column(
        children: <Widget>[
          const SizedBox(height: 100), // Spacing between buttons
          OutlinedButton.icon(
            icon: const Icon(Icons.logout, size: 75),
            label: const Text("Log Out", style: TextStyle(fontSize: 75)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.orange, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            ),
            onPressed: signOut
          ),
           ],
          ),
        ),
    );
  }
}
