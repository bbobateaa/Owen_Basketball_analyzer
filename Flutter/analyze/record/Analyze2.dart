import 'dart:convert';

import 'package:basketball_project_owen_wang/Firebase/Auth.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Firebase/Firestore.dart';
import '../../History.dart';

class Analyze2 extends StatefulWidget {
  Analyze2({
    Key? key,
    required this.videofile,
    required this.duration,
  }) : super(key: key);
  final XFile videofile;
  final int duration;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  State<Analyze2> createState() => _Analyze2State();
}

class _Analyze2State extends State<Analyze2> {
  String _userid = AuthenticationHelper().uid;

  @override
  void initState() {
    super.initState();
    startVideoProcessing();
  }

  Future<void> startVideoProcessing() async {
    try {
      // Update Firestore to indicate that processing has started
      await updateFirestoreDocumentBeforeProcessing(_userid);

      // Send the video to the server for analysis
      await sendVideoToServer(widget.videofile.path);
    } catch (e) {
      print('Error during video processing: $e');
    }
  }

  Future<void> updateFirestoreDocumentBeforeProcessing(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'is_processing': true,
      });
    } catch (e) {
      print('Error updating Firestore before processing: $e');
    }
  }

  Future<void> updateFirestoreDocumentAfterProcessing(String userId, String videoUrl, List<Map<String, dynamic>> scores) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'is_processing': false,
        'videoUrl': videoUrl,
        'scores': scores,
        '${DateTime.now().millisecondsSinceEpoch}': {
          'url': videoUrl,
          'scores': scores,
        }
      });
    } catch (e) {
      print('Error updating Firestore after processing: $e');
    }
  }

  Future<void> sendVideoToServer(String filePath) async {
    try {
      var url = 'http://10.0.2.2:5000/analyze';
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['userId'] = _userid;
      request.files.add(await http.MultipartFile.fromPath('video', filePath));

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Video uploaded successfully');

        // Assuming the server returns a JSON with videoUrl and scores
        var responseBody = await http.Response.fromStream(response);
        var responseData = jsonDecode(responseBody.body);

        String videoUrl = responseData['videoUrl'];
        List<Map<String, dynamic>> scores = List<Map<String, dynamic>>.from(responseData['scores']);

        // Update Firestore after processing is complete
        await updateFirestoreDocumentAfterProcessing(_userid, videoUrl, scores);
      } else {
        print('Failed to upload video, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading video to server: $e');
    }
  }

  String getEstimateProcessingTime() {
    double processingTimePerFrame = 0.25;
    double fps = 30;
    double totalProcessingTime =
        (widget.duration * fps * processingTimePerFrame) / 60;
    return totalProcessingTime.toStringAsFixed(0) + ' minutes';
  }

  Future<void> updateProcessingStatus(String userId, bool isProcessing) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'is_processing': isProcessing,
      });
      print('Document updated successfully');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        title: const Text(
          'Video Analysis',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 12),
        child: Center(
          child: Card(
            color: Colors.orangeAccent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.white,
                    child: Image.asset('assets/basketball.png'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Video analysis and processing in progress...',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'The processed video and statistics will be accessible on the history page.',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Estimated processing time: ${getEstimateProcessingTime()}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.home, size: 40),
                    label: const Text("Go back to home", style: TextStyle(fontSize: 40)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white, width: 2), // Border color and width
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const History()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}