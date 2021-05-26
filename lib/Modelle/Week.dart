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

  /// Generates the DateTime from the milliseconds
  DateTime getStartDate() {
    return DateTime.fromMillisecondsSinceEpoch(startdate!);
  }

  /// Generates the DateTime from the milliseconds
  DateTime getEndTime() {
    return DateTime.fromMillisecondsSinceEpoch(endDate!);
  }

  /// Generates a List of Drinks for the current week
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

  /// Calculates the SE for the current week
  double getSethisWeek() {
    List<Drinks> drinks = weekDrinks();
    double result = 0;
    for (int i = 0; i < drinks.length; i++) {
      result += drinks[i].getSE();
    }
    print("SE this week: $result");
    return result;
  }

  /// Calculates the amount of days, where the user drinks
  double getUsedDays() {
    List<Drinks> drinks = weekDrinks();
    double days = 0;
    List<int> dates = [];
    for (int i = 0; i < drinks.length; i++) {
      dates.add(drinks[i].getDate().weekday);
    }
    days = Set.from(dates).toList().length.toDouble();
    print("Used Days: $days");
    return days;
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
