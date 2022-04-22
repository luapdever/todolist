import 'dart:io';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:userlist/Models/Arguments/TaskArguments.dart';
import 'package:userlist/Models/Task.dart';
import 'package:userlist/components/appbar.dart';
import 'package:userlist/sql_db/sql_helper.dart';


class TaskScreen extends StatelessWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ToDoList",
      onGenerateRoute: (settings) {
        final args = ModalRoute.of(context)!.settings.arguments as TaskArguments;

        return MaterialPageRoute(
            builder: (context) {
              return MainScreen(idUser: args.id, fullName: args.fullName);
            },
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  late int idUser;
  late String fullName;

  MainScreen({Key? key, required this.idUser, required this.fullName }) : super(key: key);

  @override
  State<MainScreen> createState() => _UserState();
}

class _UserState extends State<MainScreen> {

  Map<String, dynamic> _task = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    SQLHelper.getItem(widget.idUser).then((value) {
      setState(() {
        _task = value[0];
        isLoading = false;
      });
    });
  }

  String showPriority(var priority) {
    String output;
    switch (priority) {
      case 1:
        output = "Low";
        break;
      case 2:
        output = "Normal";
        break;
      case 3:
        output = "High";
        break;
      default:
        output = "Normal";
    }

    return output;
  }

  Widget showStatus(var task) {
    if(DateTime.parse(task["dateStart"]).compareTo(DateTime.parse(task["dateEnd"])) < 0) {
      return Column(children: [
        const Text("Waiting", style: TextStyle(color: Colors.blue)),
        SizedBox(height: 15,
          child: ElevatedButton(
            child: const Text("Start it"),
            onPressed: () {
              var data = {
                "id": _task["id"],
                "dateStart": dateFormat(DateTime.now())
              };
              SQLHelper.updateItem(data).then((value) {
                if(value != 0) {
                  _showMsg("Task started successfully.");
                  Navigator.of(context).pushReplacementNamed("list_task");
                } else {
                  _showMsg("Task not started.");
                }
              });
            },
          ),
        )
      ]);
    } else if(DateTime.parse(task["dateStart"]).compareTo(DateTime.parse(task["dateEnd"])) == 0) {
      return Column(children: [
        const Text("Processing", style: TextStyle(color: Colors.green)),
        SizedBox(height: 15,
          child: ElevatedButton(
            child: const Text("End it"),
            onPressed: () {
              var data = {
                "id": _task["id"],
                "dateEnd": dateFormat(DateTime.now())
              };
              SQLHelper.updateItem(data).then((value) {
                if(value != 0) {
                  _showMsg("Task ended successfully.");
                  Navigator.of(context).pushReplacementNamed("list_task");
                } else {
                  _showMsg("Task not ended.");
                }
              });
            },
          ),
        )
      ]);
    } else {
      return Column(children: const [
        Text("")
      ]);
    }
  }

  String dateFormat(DateTime date) {
    if(date == null) {
      return "";
    }
    return date.year.toString() + "-" + date.month.toString().padLeft(2, "0") + "-" + date.day.toString().padLeft(2, "0");
  } 

  _showMsg(msg) {
    Toast.show(
      msg, 
      context, 
      duration: Toast.LENGTH_LONG, 
      gravity:  Toast.BOTTOM
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: BaseAppBar(titlePage: widget.fullName, context: context),
      body: isLoading 
        ? const Center(
          child: CircularProgressIndicator(),
        )
        : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            alignment: Alignment.topCenter,
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
                  Column(
                    children:  [
                      SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(_task["name"],
                            style: const TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 15,
                              letterSpacing: 3,
                            )
                          ),
                        ),
                      ),
                      const Text("DescriptionTask",
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 15,
                          letterSpacing: 3,
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_task["description"],
                          style: const TextStyle(
                            fontFamily: "RalewayN",
                            fontWeight: FontWeight.w500
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 70,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 70),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(_task["dateStart"],
                                    style: const TextStyle(
                                        fontFamily: "RalewayN",
                                        fontWeight: FontWeight.w600
                                    ),),
                                ),
                              ),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(_task["dateEnd"],
                                    style: const TextStyle(
                                        fontFamily: "RalewayN",
                                        fontWeight: FontWeight.w600
                                    ),),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(showPriority(_task["priority"]),
                            style: const TextStyle(
                                fontFamily: "Raleway",
                            ),),
                        ),
                      ),
                      const SizedBox(height: 20),
                      showStatus(_task)
                    ],
                  ),
                  Expanded(
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed("update_task");
                            },
                            icon: const Icon(Icons.edit, color:Colors.blue),
                          ),
                          IconButton(
                            onPressed: () {  },
                            icon: const Icon(Icons.delete, color:Colors.red),
                          ),
                        ],
                      ))

                ],
              ),
            ),
          ),
        ),
    );
  }
}