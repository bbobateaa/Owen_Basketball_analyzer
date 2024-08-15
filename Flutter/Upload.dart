import 'package:flutter/material.dart';
import 'package:basketball_project_owen_wang/Setting.dart';
import 'package:basketball_project_owen_wang/History.dart';
import 'package:basketball_project_owen_wang/Record.dart';
import 'package:basketball_project_owen_wang/analyze/record/UploadVideo.dart';
import 'analyze/record/Recordscreen.dart';

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  int currentPageIndex = 1;

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
                MaterialPageRoute(builder: (context) => const Upload()),
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
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 50, 0, 50),
                child: Column(
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.videocam, size: 40),
                      label: const Text("Record", style: TextStyle(fontSize: 40)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.orange, width: 2), // Border color and width
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const Recordscreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 20), // Spacing between buttons
                    OutlinedButton.icon(
                      icon: const Icon(Icons.upload_file, size: 40),
                      label: const Text("Upload Video", style: TextStyle(fontSize: 40)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.orange, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => UploadPage()),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                      child:
                      Image.asset(
                          'assets/basktball.png',
                          height: 312.2
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}