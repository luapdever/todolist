import 'dart:io';

import 'package:flutter/material.dart';
import 'package:userlist/Models/Arguments/TaskArguments.dart';
import 'package:userlist/Models/Task.dart';
import 'package:userlist/Models/User.dart';
import 'package:userlist/components/appbar.dart';
import 'package:userlist/components/drawer.dart';
import 'package:userlist/sql_db/sql_helper.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  List<Map<String, dynamic>> _listTask = [];
  bool isLoading = true;
  User? user;
  List<num> statistic = [
    0, 0, 0, 0, 0.0
  ];

  @override
  void initState() {
    super.initState();
    
    User.getUserFromStorage().then((value) {
      setState(() {
        user = value;
      });
    });
    SQLHelper.getItems().then((value) {
      setState(() {
        _listTask = value;
        isLoading = false;
        statistic = Task.getStatistic(_listTask);
      });
    });
  }

  Widget _buildRow(var task) {
    return Card(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            "task",
            arguments: TaskArguments(task["id"], task["name"])
          );
        },
        child: ListTile(
          title: Text(task["name"]),
          subtitle: Text(task["priority"].toString()),
          trailing: const Icon(Icons.remove_red_eye_outlined)
        ),
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(titlePage: "Dashboard", context: context),
      drawer: BaseDrawer(user!),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 124,
                  child: Center(
                    child: Image.asset(
                      'form.png',
                      width: 120,
                    ),
                  ),
                ),
                const Text("Task statistics"),
                const SizedBox(height: 20),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.task),
                    title: const Text("Total of tasks"),
                    subtitle: Text(statistic[0].toString()),
                  )
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.task),
                    title: const Text("Total of tasks in schedule"),
                    subtitle: Text(statistic[1].toString()),
                  )
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.task),
                    title: const Text("Total of tasks in schedule (High priority)"),
                    subtitle: Text(statistic[2].toString()),
                  )
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.task),
                    title: const Text("Total of tasks in schedule (Low priority)"),
                    subtitle: Text(statistic[3].toString()),
                  )
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.task),
                    title: const Text("Mid time of tasks processed"),
                    subtitle: Text(statistic[4].toString()),
                  )
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("list_task");
                  },
                  child: const Text("View tasks")
                ),
                const SizedBox(height: 20)
              ]
            )
          )
        )
      ),  
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 17, 18, 26),
        onPressed: () {
          Navigator.of(context).pushNamed("add_task");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}