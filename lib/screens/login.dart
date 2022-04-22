import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'package:userlist/Models/User.dart';
import 'package:userlist/components/appbar.dart';
import 'package:userlist/components/password_field.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey = GlobalKey<FormFieldState<String>>();

  bool isLoading = false;

  String? pseudo;
  final pseudoController = TextEditingController();

  String? password;
  final passwordController = TextEditingController();

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
                    const Text("Login",
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
                        const Text(
                          'Login',
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
                              _login();
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                          const Text("You don't have an account... "),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed("register");
                            },
                            child:  const Text(
                              "Register",
                              style: TextStyle(color: Colors.blue),
                            )
                          )
                        ])
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

  _login() async{
    if (_formKey.currentState!.validate()) {
      isLoading = true;

      var user = await User.getUserFromStorage();
      if(user == null) {
        _showMsg("You don't have an account.");
      } else if(pseudo == user.pseudo && password == user.password) {
        user.connected = true;
        user.save().then((value) {
          if(value) {
            _showMsg("User successfully logged.");
            Navigator.of(context).pushReplacementNamed("home");
          } else {
            _showMsg("An error is occured.");
          }
        });
      } else {
        _showMsg("Pseudo or/and password incorrect(s)");
      }
    } else {
      isLoading = false;
      _showMsg("Some field is missed.");
    }
  }
}