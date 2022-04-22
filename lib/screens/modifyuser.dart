import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:userlist/Models/User.dart';
import 'package:userlist/components/appbar.dart';

class ModifyUserScreen extends StatefulWidget {
  ModifyUserScreen({Key? key}) : super(key: key);

  @override
  State<ModifyUserScreen> createState() => _ModifyUserScreenState();
}

class _ModifyUserScreenState extends State<ModifyUserScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String? firstName;
  String? name;  
  String? telephone;

  User? user;

  _showMsg(msg) {
    Toast.show(
      msg, 
      context, 
      duration: Toast.LENGTH_LONG, 
      gravity:  Toast.BOTTOM
    );
  }

  @override
  void initState() {
    super.initState();

    User.getUserFromStorage().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: BaseAppBar(context: context, titlePage: "Profile - Update"),
        body: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          child: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Register',
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
                  controller: TextEditingController(text: user!.firstName),
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: Icon(Icons.supervised_user_circle_outlined),
                  ),
                  validator: (firstNameValue) {
                    if (firstNameValue!.isEmpty) {
                      return 'This field is required';
                    }
                    firstName = firstNameValue;
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: TextEditingController(text: user!.name),
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
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
                  keyboardType: TextInputType.phone,
                  controller: TextEditingController(text: user!.telephone),
                  decoration: const InputDecoration(
                    labelText: 'Telephone',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (telephoneValue) {
                    if (telephoneValue!.isEmpty) {
                      return 'This field is required';
                    }
                    telephone = telephoneValue;
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
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
                ),Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  const Text("You already have an account... "),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed("login");
                    },
                    child:  const Text(
                      "Login",
                      style: TextStyle(color: Colors.blue),
                    )
                  )
                ],)
              ],
            ),
          )),
        ),
      ),
    );
  }

  _saveUser() async{
    if (_formKey.currentState!.validate()) {
      isLoading = true;
      
      user!.firstName = firstName;
      user!.name = name;
      user!.telephone = telephone;

      user!.save().then((value) {
        if(value) {
          _showMsg("User successfully updated.");
          Navigator.of(context).pushReplacementNamed("home");
        } else {
          _showMsg("An error is occured.");
        }
      });
    } else {
      isLoading = false;
      _showMsg("Some field is missed.");
    }
  }
}
