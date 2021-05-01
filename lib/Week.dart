import 'package:hive/hive.dart';

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
  double? SEthisWeek;
  @HiveField(4)
  double? usedDays;
  @HiveField(5)
  int? startdate;
  @HiveField(6)
  int? endDate;

  Week({
    this.week,
    this.plannedSE,
    this.plannedDay,
    this.SEthisWeek,
    this.usedDays,
    this.startdate,
    this.endDate,
  });

  @override
  String toString() {
    return "Week:{" +
        "Week: " +
        week.toString() +
        " Planned SE: " +
        plannedSE.toString() +
        " Used SE: " +
        SEthisWeek.toString() +
        " Planned Days: " +
        plannedDay.toString() +
        " Used Days: " +
        usedDays.toString() +
        " Startdate: " + DateTime.fromMillisecondsSinceEpoch(startdate!).toString() +
        " Enddate: " + DateTime.fromMillisecondsSinceEpoch(endDate!).toString() +
        " }";
  }
}
