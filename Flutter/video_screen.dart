import 'package:basketball_project_owen_wang/video_items.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({
    Key? key,
    required this.videoUrl,
    required this.scores,
    required this.date,
  }) : super(key: key);

  final String videoUrl;
  final List<Map<String, dynamic>> scores;
  final String date;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController? _controller1;

  @override
  void initState() {
    super.initState();
    _setVideoController();
  }

  Future<void> _setVideoController() async {
    setState(() {
      _controller1 = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    });
  }

  void showNotification(BuildContext context, List<Map<String, dynamic>> scores) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.orangeAccent,
          title: const Text('Score Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: scores.map((score) {
                return ListTile(
                  title: Text('Score: ${score['score']}'),
                  subtitle: Text(
                    'Right Score: ${score["right"]}\n'
                        'Left Score: ${score['left']}\n'
                        'Person Position: ${score['person_pos'].toStringAsFixed(2)}',
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
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
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.date,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _controller1 != null
          ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
          child: Card(
            color: Colors.orange,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Image.asset('assets/logo.png'),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.orangeAccent,
                    child: ListTile(
                      title: Text('Scores'),
                      trailing: Icon(Icons.info, color: Colors.blueAccent),
                      onTap: () {
                        showNotification(context, widget.scores);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    color: Colors.black,
                    height: 250,
                    child: VideoItems(
                      videoPlayerController: _controller1!,
                      autoplay: false,
                      looping: false,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      )
          : const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Loading Video Error',
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}