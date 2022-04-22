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
      body: isLoading ? 
        const Center(child: CircularProgressIndicator())
        : Container(
          padding: const EdgeInsets.only(
            top: 16.0
          ),
          child: Column(
            children: [
              Title(
                color: const Color.fromARGB(255, 17, 18, 26),
                child: const Text(
                  "List of tasks",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                  ),
                )
              ),
              _listTask.isEmpty 
              ? Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(8.0),
                child: const Text("No task for a moment."),
              )
              : ListView.builder(
                itemCount: _listTask.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  var user = _listTask[index];
                  return _buildRow(user);
                }
              )
            ],
          ),
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