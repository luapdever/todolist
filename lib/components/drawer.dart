import 'package:flutter/material.dart';


class BaseAppBar extends Drawer {
  
  BaseAppBar({ Key? key, required BuildContext context }) : super(key: key, 
    backgroundColor: const Color.fromRGBO(17, 0, 104, 1),
    child: ListView(
      children: const [
        DrawerHeader(
          // margin: const EdgeInsets.only(bottom: 0),
          // padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
          child: Text(
            "Name"
          )
        ),
        ListTile(
          leading: Icon(Icons.message),
          title: Text('Mes messages'),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Mon profil'),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Parametres'),
        ),
      ],
    ),
  );
}