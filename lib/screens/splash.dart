import 'dart:async';
import 'package:flutter/material.dart';
import 'package:userlist/Models/User.dart';
import 'package:userlist/screens/welcome.dart';
import 'package:userlist/sql_db/sql_helper.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? userConnected;

  @override
  void initState() {
    super.initState();
    User.isLogged().then((value) {
      setState(() {
        userConnected = value;
      });
    });
    SQLHelper.db();
    Timer(
      const Duration(seconds: 3),
      () {
        if(userConnected!) {
          Navigator.of(context).pushReplacementNamed("home");
        } else {
          Navigator.of(context).pushReplacementNamed("welcome");
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 18, 26),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'splash.png',
              width: 80,
            ),
            const Divider(),
            const Text(
              "TODO LIST",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0
              )
            )
          ],
        ),
      ),
    );
  }
}
