import 'package:aloha/Modelle/Drinks.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../Modelle/Drinks.dart';
import 'DetailsPage.dart';

class TimelinePage extends StatefulWidget {
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final box = Hive.box("drinks");
  final weekBox = Hive.box("Week");

  @override
  void initState() {
    super.initState();
    print("Weeks: " + weekBox.length.toString());
    print("TimeLinePage initialized");
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: weekBox.length,
      itemBuilder: (context, index) {
        return TimeLineWeek(index);
      },
    );
  }
}

class TimeLineWeek extends StatefulWidget {
  final int? week;

  TimeLineWeek(this.week);

  @override
  _TimeLineWeekState createState() => _TimeLineWeekState(week);
}

class _TimeLineWeekState extends State<TimeLineWeek> {
  final int? week;
  final box = Hive.box("drinks");
  List<int>? listFromWeek;

  _TimeLineWeekState(this.week);

  @override
  void initState() {
    listFromWeek = generateList();
    print("TimeLineWeek initialized: " + week.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Woche $week",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          TimeLineGrid(
            box: listFromWeek,
          ),
        ],
      ),
    );
  }

  /// Generates a list with all weeks from the drinks
  List<int> generateList() {
    List<int> generated = [];
    for (int i = 0; i < box.length; i++) {
      Drinks current = box.getAt(i);
      if (current.week == week) {
        generated.add(i);
      }
    }
    print("GeneratedList for " +
        generated.toString() +
        " in TimeLineWeek: " +
        week.toString());
    return generated;
  }
}

class TimeLineGrid extends StatefulWidget {
  final List<int>? box;

  const TimeLineGrid({Key? key, this.box}) : super(key: key);

  @override
  _TimeLineGridState createState() => _TimeLineGridState(box);
}

class _TimeLineGridState extends State<TimeLineGrid> {
  final List<int>? box;

  _TimeLineGridState(this.box);

  @override
  void initState() {
    print("TimeLineGrid initialized: " + box.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      primary: false,
      crossAxisCount: 3,
      padding: EdgeInsets.all(10),
      children: List.generate(
        box!.length,
        (index) {
          return GestureDetector(
            child: GetraenkeListItem(box!.elementAt(index)),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetailsTab(box!.elementAt(index)),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GetraenkeListItem extends StatefulWidget {
  final int id;

  GetraenkeListItem(this.id);

  @override
  _GetraenkeListItemState createState() => _GetraenkeListItemState(id);
}

class _GetraenkeListItemState extends State<GetraenkeListItem> {
  final int id;
  final box = Hive.box("drinks");
  SizedBox? _image;
  Drinks? currentDrink;

  _GetraenkeListItemState(this.id);

  @override
  void initState() {
    currentDrink = box.getAt(id);
    _image = currentDrink!.getImage(60.0, 90.0);
    print("ListItem: " +id.toString() + " - " + currentDrink.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.black38,
      child: ListView(
        primary: false,
        shrinkWrap: true,
        children: [
          _image!,
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Card(
              color: Colors.black26,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Padding(
                padding: EdgeInsets.all(3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text(
                        currentDrink!.name.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(currentDrink!.volume.toString() + " ml"),
                    Text(currentDrink!.volumepart!.toStringAsPrecision(2) +
                        " vol%"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}