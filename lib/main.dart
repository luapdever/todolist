import 'package:userlist/screens/AddTask.dart';
import 'package:userlist/screens/ListTaskScreen.dart';
import 'package:userlist/screens/Task.dart';
import 'package:userlist/screens/home.dart';
import 'package:userlist/screens/login.dart';
import 'package:userlist/screens/modify_task.dart';
import 'package:userlist/screens/modifyuser.dart';
import 'package:userlist/screens/register.dart';

import 'screens/welcome.dart';
import '/screens/splash.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: "ToDoList",
      //home: RegisterScreen(),
      home: StartApp(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "home": (context) => HomeScreen(),
        "welcome": (context) => WelcomeScreen(),
        "list_task": (context) => ListTaskScreen(),
        "login": (context) => LoginScreen(),
        "register": (context) => RegisterScreen(),
        "task": (context) => TaskScreen(),
        "add_task": (context) => AddTaskScreen(),
        "update_task": (context) => UpdateTaskScreen(),
        "update_user": (context) => ModifyUserScreen(),
      },
    );
  }
}

class StartApp extends StatefulWidget {
  @override
  _StartAppState createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Widget child;
      child = SplashScreen();
    return Scaffold(
      body: child,
    );
  }
}
