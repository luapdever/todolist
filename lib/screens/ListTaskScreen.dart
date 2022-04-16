import 'dart:io';

import 'package:flutter/material.dart';
import 'package:userlist/Models/Arguments/UserArguments.dart';
import 'package:userlist/Models/Task.dart';
import 'package:userlist/components/appbar.dart';
import 'package:userlist/sql_db/sql_helper.dart';

class ListTaskScreen extends StatefulWidget {
  ListTaskScreen({Key? key}) : super(key: key);

  @override
  State<ListTaskScreen> createState() => _ListTaskScreenState();
}

class _ListTaskScreenState extends State<ListTaskScreen> {

  List<Map<String, dynamic>> _listTask = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    
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
            arguments: UserArguments(task["id"], task["name"])
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
      appBar: BaseAppBar(titlePage: "List", context: context),
      body: isLoading ? 
        const Center(child: CircularProgressIndicator())
        : Container(
          padding: const EdgeInsets.only(
            top: 16.0
          ),
          child: Column(
            children: [
              Title(
                color: const Color.fromRGBO(17, 0, 104, 1),
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
        backgroundColor: const Color.fromRGBO(17, 0, 104, 1),
        onPressed: () {
          Navigator.of(context).pushNamed("add_task");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}