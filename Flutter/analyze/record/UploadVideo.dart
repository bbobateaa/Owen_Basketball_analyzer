import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import '../../History.dart';
import '../../Setting.dart';
import '../../Upload.dart';
import 'Analyze2.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:basketball_project_owen_wang/video_items.dart';

class UploadPage extends StatefulWidget {
  UploadPage({
    Key? key,
  }) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  VideoPlayerController? _controller1;
  XFile? _video1File;

  final ImagePicker _picker = ImagePicker();

  Future<void> _setVideoController(XFile file, isVideo1) async {
    if (file != null && mounted) {
      VideoPlayerController controller;
      print('play video ');
      if (kIsWeb) {
        controller = VideoPlayerController.networkUrl(Uri.parse(file.path));
        print('network:' + file.path);
      } else {
        controller = VideoPlayerController.file(File(file.path));
        print('file:' + file.path);
      }
      setState(() {
        _controller1 = controller;
      });
    }
  }

  void _onVideo1ButtonPressed(ImageSource source) async {
    _video1File = await _picker.pickVideo(source: source);
    await _setVideoController(_video1File!, true);
  }

  @override
  Widget build(BuildContext context) {
    int currentPageIndex = 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Video'),
        elevation: 0,
        backgroundColor: Colors.orangeAccent,
      ),
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
                  MaterialPageRoute(builder: (context) => History(),
                  ));
              break;
            case 1:
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Upload(),
                  ));
              break;
            case 2:
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Setting(),
                  ));
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
      body: _controller1 != null
          ? SingleChildScrollView(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 22.0, horizontal: 10),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: Image.asset('assets/basketball.png')),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.black,
                      height: 250,
                      child: VideoItems(
                        videoPlayerController: _controller1!,
                        autoplay: false,
                        looping: false,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => Analyze2(
                                      duration: _controller1!
                                          .value.duration.inSeconds,
                                      videofile: _video1File!,
                                    ))).then((value) {
                              setState(() {
                                if (_controller1 != null) {
                                  _controller1!.dispose();
                                  _controller1 = null;
                                }
                              });
                            });
                          },
                          child: const Text(
                            'Analyze Videos',
                            style:
                            TextStyle(fontSize: 22, color: Colors.white),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ))
          : Center(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
            child: Card(
              color: Colors.white,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: Image.asset('assets/bask.png',
                            fit: BoxFit.fitHeight)),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Basketball Analyzer',
                      style: const TextStyle(fontSize: 30),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: () {
                          _onVideo1ButtonPressed(ImageSource.gallery);
                        },
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload_rounded,
                              size: 50.0,
                              semanticLabel: 'Select Video',
                              color: Colors.black54,
                            ),
                            Text(
                              'Upload Video',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ]),
            ),
          )),
    );
  }
}