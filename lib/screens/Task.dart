import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:userlist/Models/Arguments/UserArguments.dart';
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
        final args = ModalRoute.of(context)!.settings.arguments as UserArguments;

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
                  Title(
                    color: const Color.fromRGBO(17, 0, 104, 1),
                    child: Text(
                      _task["name"],
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                  const SizedBox(height: 20),
                  Text(_task["description"].toString()),
                  const SizedBox(height: 20),
                  Card(child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 5),
                        Text(_task["priority"].toString())
                      ],
                    ),
                  )),
                  Card(child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.date_range),
                        const SizedBox(width: 5),
                        Text(_task["dateStart"].toString())
                      ],
                    ),
                  )),
                  Card(child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.date_range),
                        const SizedBox(width: 5),
                        Text(_task["dateEnd"].toString())
                      ],
                    ),
                  )),
                ],
              )
            ),
          ),
        ),
    );
  }
}