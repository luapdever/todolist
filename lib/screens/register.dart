import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:userlist/Models/User.dart';

import 'package:userlist/components/appbar.dart';
import 'package:userlist/components/password_field.dart';
import 'package:userlist/sql_db/sql_helper.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey = GlobalKey<FormFieldState<String>>();

  bool isLoading = false;

  String? firstName;
  final firstNameController = TextEditingController();

  String? name;
  final nameController = TextEditingController();
  
  String? telephone;
  final telephoneController = TextEditingController();

  String? pseudo;
  final pseudoController = TextEditingController();

  String? password;
  final passwordController = TextEditingController();


  _showMsg(msg) {
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
      
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Column(
          children: [
            SizedBox(
                height: 300,
                width: 500,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 300.0, top: 50),
                      child: Column(
                        children: [
                          IconButton(
                              onPressed:(){
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Color.fromARGB(255, 17, 18, 26),
                                size: 23,
                              )
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Image.asset(
                          'assets/icon.png',
                          width: 130,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text("Registrer",
                            style: TextStyle(
                              color: Color.fromARGB(255, 17, 18, 26),
                              fontSize:20,
                              fontFamily: "Raleway",
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  ],
                )
            ),
            Expanded(
                child:Padding(
                  padding: const EdgeInsets.only(left:50.0, right:50.0, top:0),
                  child: Container(
                    child: SingleChildScrollView(
                        child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: firstNameController,
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
                            controller: nameController,
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
                            controller: telephoneController,
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
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.streetAddress,
                            controller: pseudoController,
                            decoration: const InputDecoration(
                              labelText: 'Pseudo',
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (pseudoValue) {
                              if (pseudoValue!.isEmpty) {
                                return 'This field is required';
                              }
                              pseudo = pseudoValue;
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          PasswordField(
                            fieldkey: _passwordFieldKey,
                            helperText: "No more than 8 characters.",
                            labelText: "Password *",
                            validator: (passwordValue) {
                              if (passwordValue!.isEmpty) {
                                return 'This field is required';
                              }
                              password = passwordValue;
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
                )
            )
          ],
        ),
    );
  }

  _saveUser() async{
    if (_formKey.currentState!.validate()) {
      isLoading = true;
      User user = User.withBody(firstName, name, telephone, pseudo, password);

      user.save().then((value) {
        if(value) {
          //_showMsg("User successfully registered.");
          Navigator.of(context).pushReplacementNamed("login");
        } else {
          //_showMsg("An error is occured.");
        }
      });
    } else {
      isLoading = false;
     // _showMsg("Some field is missed.");
    }
  }
}