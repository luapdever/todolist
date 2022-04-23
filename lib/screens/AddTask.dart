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

  _showMsg(msg, context) {
    Toast.show(
      msg,
      duration: Toast.lengthLong,
      gravity:  Toast.bottom
    );
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      dateStart = DateTime.parse(DateTime.now().toString());
      dateEnd = dateStart!.add(const Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(titlePage: "Register", context: context),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          child: SingleChildScrollView(
              child: Form(
            key: _formKey,
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
                Container(
                  child: const Center(
                    child: Text("Do not waste anymore time.",
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 17,
                        )
                    ),
                  ),
                ),
                Container(
                  child: const Center(
                    child: Text("Get organized!",
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 17,
                        )
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
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

                Row(
                  children: const [
                    Text("Priority")
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      activeColor: Colors.black,
                      value: 1,
                      groupValue: priority,
                      onChanged: (int? value) {
                        if(value != null) {
                          setState(() {
                            priority = value;
                          });
                        }
                      }
                    ),
                    const Text("Low"),
                    const SizedBox(width: 10),
                    Radio(
                      activeColor: Colors.blue,
                      value: 2,
                      groupValue: priority,
                      onChanged: (int? value) {
                        if(value != null) {
                          setState(() {
                            priority = value;
                          });
                        }
                      }
                    ),
                    const Text("Normal", style: TextStyle(color: Colors.blue)),
                    const SizedBox(width: 10),
                    Radio(
                      activeColor: Colors.red,
                      value: 3,
                      groupValue: priority,
                      onChanged: (int? value) {
                        if(value != null) {
                          setState(() {
                            priority = value;
                          });
                        }
                      }
                    ),
                    const Text("High", style: TextStyle(color: Colors.red)),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      hintText: 'Description',
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
                      initialDate: DateTime.parse(dateFormat(dateStart!)),
                      firstDate: DateTime.parse(dateFormat(dateStart!)),
                      lastDate: DateTime.parse("2032-12-29"),
                    );
                    
                    if(mounted && dateTime != null) {
                      setState(() {
                        dateStart = dateTime;
                        dateEnd = dateStart!.add(const Duration(days: 1));
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
                      initialDate: DateTime.parse(dateFormat(dateStart!.add(const Duration(days: 1)))),
                      firstDate: DateTime.parse(dateFormat(dateStart!.add(const Duration(days: 1)))),
                      lastDate: DateTime.parse("2032-12-29"),
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
          //_showMsg("Task added successfully.");
          Navigator.of(context).pushReplacementNamed("list_task");
        } else {
          //_showMsg("Task not added.");
        }
      });
    } else {
      isLoading = false;
     // _showMsg("Some field is missed.");
    }
  }
}