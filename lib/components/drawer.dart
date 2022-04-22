import 'package:flutter/material.dart';
import 'package:userlist/Models/User.dart';
// import 'package:animate_do/animate_do.dart';

class BaseDrawer extends Drawer {
  User user;

  BaseDrawer(this.user);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:Column(
        children: <Widget> [
          DrawerHeader(
            padding: const EdgeInsets.only(top: 120.0, left: 20),
            decoration:const BoxDecoration(
              image:DecorationImage(
                image:AssetImage(
                  'assets/person.png'
                ),
                fit: BoxFit.cover,
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(user != null ? user.pseudo! : "Pseudo",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  )
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("update_user");
                      },
                      icon: const Icon(Icons.edit, color:Colors.blue),
                    ),
                    IconButton(
                      onPressed: () {
                        User.destroy();
                        Navigator.of(context).pushNamed("welcome");
                      },
                      icon: const Icon(Icons.delete, color:Colors.red),
                    ),
                  ],
                )
              ],
            )
          ),
          ListTile(
            leading: const Icon(Icons.people_alt_outlined,color:Color.fromARGB(255, 17, 18, 26)),
            title: Text(user != null ? user.firstName! : "Prenom"),
          ),
          ListTile(
            leading: const Icon(Icons.person,color:Color.fromARGB(255, 17, 18, 26)),
            title: Text(user != null ? user.name! : "Name"),
          ),
          ListTile(
            leading: const Icon(Icons.phone,color:Color.fromARGB(255, 17, 18, 26)),
            title: Text(user != null ? user.telephone! : "téléphone"),
          ),
          //  Expanded(
          //    child: Container(
          //      padding: const EdgeInsets.only(left:10),
          //      child: Row(
          //        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //        crossAxisAlignment: CrossAxisAlignment.end,
          //        children: [
          //          FadeIn(
          //            child: const Text("Powered by Flutter🍃",
          //                style: TextStyle(
          //                  color: Colors.black,
          //                  fontSize: 15,
          //                  fontFamily: "Raleway",
          //                )
          //            ),
          //          ),
          //        ],
          //      ),
          //    ),
          //  )

        ],
      )
    );
  }
}
