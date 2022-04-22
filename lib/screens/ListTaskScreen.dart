import 'dart:io';

import 'package:flutter/material.dart';
import 'package:userlist/Models/Arguments/TaskArguments.dart';
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

  Widget showStatus(var task) {
    if(DateTime.parse(task["dateStart"]).compareTo(DateTime.parse(task["dateEnd"])) < 0) {
      return Column(children: const [
        Text("Waiting", style: TextStyle(color: Colors.blue)),
      ]);
    } else if(DateTime.parse(task["dateStart"]).compareTo(DateTime.parse(task["dateEnd"])) == 0) {
      return Column(children: const [
        Text("Processing", style: TextStyle(color: Colors.green)),
      ]);
    } else {
      return Column(children: const [
        Text("Finished", style: TextStyle(color: Colors.blue))
      ]);
    }
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
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5.0, top:10),
            child: Text(task["name"],
              style: const TextStyle(
                fontFamily: "Raleway",
              )
            ),
          ),
          subtitle: Column(
            children:  [
              Text(task["description"],
                style: const TextStyle(
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.justify,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  showStatus(task),
                  IconButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed(
                        "task",
                        arguments: TaskArguments(task["id"], task["name"])
                      );
                    },
                    icon: const Icon(Icons.remove_red_eye_outlined),
                  ),
                  IconButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed(
                        "update_task",
                        arguments: TaskArguments(task["id"], task["name"])
                      );
                    },
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
                  ),
                ],
              )
            ],
          )
        )
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(titlePage: "Home", context: context),
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