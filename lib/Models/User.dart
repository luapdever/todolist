import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class User {
  String? firstName;
  String? name;
  String? telephone;
  String? pseudo;
  String? password;
  bool connected = false;

  User(var user) {
    firstName = user["firstName"];
    name = user["name"];
    telephone = user["telephone"];
    pseudo = user["pseudo"];
    password = user["password"];
    connected = user["connected"];
  }

  User.withBody(
    this.firstName,
    this.name,
    this.telephone,
    this.pseudo,
    this.password
  );

  String getFullName() {
    return firstName! + " " + name!;
  }
  
  Future<bool> save() async{
    var data = {
      "firstName": firstName,
      "name": name,
      "telephone": telephone,
      "pseudo": pseudo,
      "password": password,
      "connected": connected,
    };
    String user = jsonEncode(data);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return localStorage.setString("user", user);
  }

  static Future<dynamic> getUserFromStorage() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String data = localStorage.getString("user");
    
    if(data == null) {
      return null;
    }
    return User(jsonDecode(data));
  }

  static Future<bool> isLogged() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String data = localStorage.getString("user");
    
    if(data == null) {
      return false;
    }
    return User(jsonDecode(data)).connected;
  }

  static Future<bool> destroy() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return localStorage.setString("user", null);
  }
}