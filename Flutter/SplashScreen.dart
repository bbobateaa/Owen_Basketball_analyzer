import 'package:flutter/material.dart';
import '/Login_page.dart';


class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);


  @override
  State<Splashscreen> createState() => _SplashscreenState();
}


class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await Future
        .delayed(const Duration(seconds: 4))
        .then((value) {
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => Login_page()));
    });
  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets. fromLTRB(5, 50, 5, 5),
                child: Text(
                  'Basketball Analyzer',
                      style: TextStyle(
                    color: Colors.deepOrange, fontSize: 40, fontWeight: FontWeight.normal),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets. fromLTRB(0, 10, 0, 20),
            child: Text(
              'Made by Owen Wang',
              style: TextStyle(
                color: Colors.deepOrange, fontSize: 30, fontStyle: FontStyle.italic),
            ),
            ),
            Image.asset(
              'assets/basketball.png',
              height: 550,
            ),
          ],
        ),
      ),
    );
  }
}

