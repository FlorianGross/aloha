import 'package:hive/hive.dart';

import 'Drinks.dart';

part 'Week.g.dart';

@HiveType(typeId: 1)
class Week extends HiveObject {
  @HiveField(0)
  int? week;
  @HiveField(1)
  double? plannedSE;
  @HiveField(2)
  double? plannedDay;
  @HiveField(3)
  int? startdate;
  @HiveField(4)
  int? endDate;

  Week({
    this.week,
    this.plannedSE,
    this.plannedDay,
    this.startdate,
    this.endDate,
  });

  List<Drinks> weekDrinks() {
    final box = Hive.box('drinks');
    List<Drinks> drinks = [];
    for (int i = 0; i < box.length; i++) {
      if (box.getAt(i).week == week) {
        drinks.add(box.getAt(i));
      }
    }
    return drinks;
  }

  double getSethisWeek() {
    List<Drinks> drinks = weekDrinks();
    double result = 0;
    for(int i= 0; i< drinks.length; i++){
      result += drinks[i].getSE();
    }
    return result;
  }

  double calculateSE(int session) {
    final box = Hive.box('drinks');
    double se = 0;
    for (int i = 0; i < box.length; i++) {
      Drinks index = box.getAt(i);
      if (index.session == session) {
        se += index.getSE();
      }
    }
    return se;
  }

  @override
  String toString() {
    return "Week:{" +
        "Week: " +
        week.toString() +
        " Planned SE: " +
        plannedSE.toString() +
        " Planned Days: " +
        plannedDay.toString() +
        " Startdate: " +
        DateTime.fromMillisecondsSinceEpoch(startdate!).toString() +
        " Enddate: " +
        DateTime.fromMillisecondsSinceEpoch(endDate!).toString() +
        " }";
  }
}
