import 'dart:io';

import 'package:flutter/material.dart';
import 'package:userlist/components/appbar.dart';
import 'package:userlist/sql_db/sql_helper.dart';
import 'package:toast/toast.dart';

class AddTaskScreen extends StatefulWidget {
  AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}


class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String? name;
  final nameController = TextEditingController();

  DateTime? dateStart;
  final dateStartController = TextEditingController();

  DateTime? dateEnd;
  final dateEndController = TextEditingController();

  int? priority;
  final priorityController = TextEditingController();

  String? description;
  final descriptionController = TextEditingController();


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
      duration: Toast.LENGTH_SHORT, 
      gravity:  Toast.BOTTOM
    );
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      dateStart = DateTime.parse("2000-01-01");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(titlePage: "Register", context: context),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Task Form ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Color.fromRGBO(17, 0, 104, 1)
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Task name',
                    prefixIcon: Icon(Icons.supervised_user_circle_outlined),
                  ),
                  validator: (nameValue) {
                    if (nameValue!.isEmpty) {
                      return 'This field is required';
                    }
                    name = nameValue;
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: priorityController,
                  decoration: const InputDecoration(
                    labelText: 'Task priority',
                    prefixIcon: Icon(Icons.supervised_user_circle_outlined),
                  ),
                  validator: (priorityValue) {
                    if (priorityValue!.isEmpty) {
                      return 'This field is required';
                    }
                    priority = priorityValue as int;
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      hintText: 'description',
                  ),
                  validator: (descriptionValue) {
                    if (descriptionValue!.isEmpty) {
                      return 'This field is required';
                    }
                    description = descriptionValue;
                    return null;
                  },
                  maxLines: 4,
                ),
                const SizedBox(
                  height: 15,
                ),

                TextFormField(
                  keyboardType: TextInputType.none,
                  controller: TextEditingController(text: dateFormat(dateStart!)),
                  decoration: const InputDecoration(
                    labelText: 'Date Start',
                    prefixIcon: Icon(Icons.calendar_month_outlined),
                  ),
                  onTap: () async {
                    DateTime? dateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.parse("2022-04-16"),
                      firstDate: DateTime.parse("2022-04-16"),
                      lastDate: DateTime.now()
                    );
                    
                    if(mounted && dateTime != null) {
                      setState(() {
                        dateStart = dateTime;
                      });
                    }
                  },
                  validator: (dateStartValue) {
                    if (dateStartValue!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.none,
                  controller: TextEditingController(text: dateFormat(dateEnd!)),
                  decoration: const InputDecoration(
                    labelText: 'Date End',
                    prefixIcon: Icon(Icons.calendar_month_outlined),
                  ),
                  onTap: () async {
                    DateTime? dateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.parse("2022-04-16"),
                      firstDate: DateTime.parse(dateFormat(dateStart!)),
                      lastDate: DateTime.now()
                    );
                    
                    if(mounted && dateTime != null) {
                      setState(() {
                        dateEnd = dateTime;
                      });
                    }
                  },
                  validator: (dateEndValue) {
                    if (dateEndValue!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(
                  height: 20,
                ),
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      _saveUser();
                    },
                    color: Colors.blue,
                    child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }

  _saveUser() {
    if (_formKey.currentState!.validate()) {
      isLoading = true;
      var data = {
        'name': name,
        'priority': priority,
        'description': description,
        'dateStart': dateFormat(dateStart!),
        'dateEnd': dateFormat(dateEnd!),
      };

      SQLHelper.createItem(data).then((value) {
        if(value != 0) {
          _showMsg("Task added successfully.");
          Navigator.of(context).pushReplacementNamed("list_user");
        } else {
          _showMsg("Task not added.");
        }
      });
    } else {
      isLoading = false;
      _showMsg("Some field is missed.");
    }
  }
}