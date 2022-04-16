
import 'package:userlist/sql_db/sql_helper.dart';

class Task {
  List<Map<String, dynamic>> task = [];

  static String getFullName(var task) {
    return task["firstName"] + " " + task["name"];
  }

  Task() {
    SQLHelper.getItems().then((value) {
      task = value;
    });
  }
}