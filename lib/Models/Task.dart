
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

  static List<num> getStatistic(List<Map<String, dynamic>> tasks) {
    List<num> statistic = [0, 0, 0, 0, 0];

    statistic[0] = tasks.length;
    statistic[1] = tasks.where((task) => DateTime.parse(task["dateStart"]).compareTo(DateTime.now()) < 0).length;
    statistic[2] = tasks.where((task) => DateTime.parse(task["dateStart"]).compareTo(DateTime.now()) < 0 && task["priority"] == 3).length;
    statistic[3] = tasks.where((task) => DateTime.parse(task["dateStart"]).compareTo(DateTime.now()) < 0 && task["priority"] == 1).length;
    //var tasks_processed = tasks.where((task) => DateTime.now().compareTo(DateTime.parse(task["dateEnd"])) > 0);

    return statistic;
  }
}