import 'dart:async';

import 'package:flutter/material.dart';

// import 'dart:convert';
// import "package:userlist/Https/request.dart";

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? name;
  TextStyle textStyle = const TextStyle( color: Colors.white, letterSpacing: 12 );
  String timeOfDday = "Loading...";
  Timer? _timer;

  _date_time() {
    var now_time = DateTime.now();
    setState(() {
      timeOfDday = now_time.hour.toString().padLeft(2, '0') + " : "
                  + now_time.minute.toString().padLeft(2, '0') + " : "
                  + now_time.second.toString().padLeft(2, '0');
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timer = timer;
      });
      _date_time();
    });
    Timer(const Duration(milliseconds: 1300), () {
      setState(() {
        textStyle = const TextStyle( color: Color(0xFF110068), letterSpacing: 0 );
      });
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("list_bg.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.softLight),
          )
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AnimatedDefaultTextStyle(
                  style: textStyle,
                  duration: const Duration(seconds: 1),
                  child: const Text(
                    "Welcome !",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  timeOfDday,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("login");
                      },
                      child: const Text("Login")
                    ),
                  ],
                )
              ],
            )
          ),
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Container();
  // }
}
