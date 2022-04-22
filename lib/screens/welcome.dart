import 'dart:async';

import 'package:flutter/material.dart';

// import 'dart:convert';
// import "package:userlist/Https/request.dart";

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Widget Top=Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const SizedBox(
        height: 50,
      ),
      Image.asset(
        'assets/icon.png',
        width: 150,
      ),
      const Text("TO DO",
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w900,
        ),),
      const Text("Reminds Everythings",
        style: TextStyle(
            fontSize: 17,
            fontFamily: "Raleway",
            color: Colors.grey
        ),),
    ],
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor:const Color.fromARGB(243, 243, 243, 243),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 400,
            width: 500,
            color:const Color.fromARGB(243, 243, 243, 243),
            child:Container(
              child: Top,
            )
          ),
          Expanded(
              child: Container(
                width: 500,
                color: const Color.fromARGB(255, 17, 18, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child:ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushNamed("register");
                          },
                          style:ElevatedButton.styleFrom(
                            primary:const Color.fromARGB(255, 11, 11, 19),
                            onPrimary: Colors.white,
                            shadowColor: Colors.white60,
                            elevation: 5,
                            shape: const StadiumBorder(),
                          ),
                          icon:const Icon(Icons.perm_identity_sharp),
                          label: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text("Registrer",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                )
                            ),
                          )
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Container(
                      child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushNamed("login");
                          },
                          style:ElevatedButton.styleFrom(
                            primary:const Color.fromARGB(255, 11, 11, 19),
                            onPrimary: Colors.white,
                            shadowColor: Colors.white60,
                            elevation: 5,
                            shape: const StadiumBorder(),
                          ),
                          icon:const Icon(Icons.people_alt_outlined),
                          label: const Padding(
                            padding: EdgeInsets.only(top:10.0, bottom:10.0, right:30.0,left: 30.0),
                            child: Text("Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                )
                            ),
                          )
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text("Entrust us with your notes, we take care of everything",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Raleway",
                    )
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),

          )
          )

        ]
      )
    );
  }
}
