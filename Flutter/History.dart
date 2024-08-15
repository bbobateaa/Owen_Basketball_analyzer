import 'package:basketball_project_owen_wang/video_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Firebase/Auth.dart';
import 'Firebase/Firestore.dart';
import 'Setting.dart';
import 'Upload.dart';
import 'analyze/record/VideoPage.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int currentPageIndex = 0;
  String _userId = AuthenticationHelper().uid;
  bool _isAscending = true;
  List<String> sortedKeys = [];

  void showScores(
      BuildContext context, String message, timestamp, videoUrl, scores) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Score Information'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('View video',
                  style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoScreen(
                        date: timestamp.toString().substring(0, 16),
                        videoUrl: videoUrl,
                        scores: scores),
                  ),
                );
              },
            ),
          ],
        );
      },
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
                MaterialPageRoute(builder: (context) => const History()),
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
      body: Column(
        children: [
          Card(
            color: Colors.orangeAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Sort by Date/Time:',
                      style: TextStyle(color: Colors.white)),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isAscending = !_isAscending;
                    });
                  },
                  icon: Icon(_isAscending
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down_sharp, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: getData(_userId),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  // User's document not found
                  return const Center(child: Text('User document not found'));
                } else {
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  bool isProcessing = data.containsKey('is_processing') &&
                      data['is_processing'];
                  if (_isAscending) {
                    sortedKeys = data.keys.toList()
                      ..sort((a, b) => b.compareTo(a));
                  } else {
                    sortedKeys = data.keys.toList()
                      ..sort((a, b) => a.compareTo(b));
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        String key = sortedKeys[index];
                        if (key == 'is_processing') {
                          return isProcessing
                              ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Color.fromRGBO(169, 38, 38, 1.0),
                              // Customize the color as needed
                              padding: const EdgeInsets.all(16.0),
                              child: const Text(
                                'Video processing is in progress...',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                              : const SizedBox();
                        } else {
                          int time = double.parse(key).toInt() * 1000;
                          final timestamp =
                          DateTime.fromMillisecondsSinceEpoch(time);
                          final scores = List<Map<String, dynamic>>.from(
                              data[key]['scores']);
                          final videoUrl = data[key]['url'];
                          final lastScore =
                          scores.isNotEmpty ? scores.last : null;

                          return Card(
                            color: Colors.orange,
                            child: ListTile(
                              title: Text(
                                  'Date/Time: ${timestamp.toString().substring(0, 16)}'),
                              // subtitle: Text(
                              //     'Total Score: ${lastScore != null ? lastScore['score'] : 'N/A'}\nRight Score: ${lastScore != null ? lastScore['right'] : 'N/A'}\nLeft Score: ${lastScore != null ? lastScore['left'] : 'N/A'}'),
                              // // Add more fields if needed

                              trailing: IconButton(
                                icon: const Icon(Icons.more_vert,
                                    color: Colors.black),
                                // style: ElevatedButton.styleFrom(
                                // backgroundColor: primaryColor),
                                onPressed: () {
                                  if (lastScore != null) {
                                    showScores(
                                      context,
                                      'Total Score: ${lastScore['score']}\nRight Score: ${lastScore['right']}\nLeft Score: ${lastScore['left']}',
                                      timestamp,
                                      videoUrl,
                                      scores,
                                    );
                                  } else {
                                    showScores(
                                      context,
                                      'No scores available',
                                      timestamp,
                                      videoUrl,
                                      scores,
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}