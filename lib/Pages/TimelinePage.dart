import 'package:dieBruecke/BrueckeIcons.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../Drinks.dart';
import 'DetailsPage.dart';

class TimelinePage extends StatefulWidget {
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final box = Hive.box("drinks");
  late List<int?> weeks;

  @override
  void initState() {
    weeks = generateWeeks();
    super.initState();
    print("TimeLinePage initialized");
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: weeks.length,
      itemBuilder: (context, index) {
        return TimeLineWeek(week: index);
      },
    );
  }

  List<int?> generateWeeks() {
    List<int?> generate = [];
    for (int i = 0; i < box.length; i++) {
      Drinks current = box.getAt(i);
      generate.add(current.week);
    }
    generate = generate.toSet().toList();
    print("Generated Weeks: " + generate.toString());
    return generate;
  }
}

class TimeLineWeek extends StatefulWidget {
  final int? week;

  const TimeLineWeek({Key? key, this.week}) : super(key: key);

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
    print("TimeLineWeek initialized");
    listFromWeek = generateList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(
            "Woche: $week",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            textAlign: TextAlign.left,
          ),
          TimeLineGrid(
            box: listFromWeek,
          ),
        ],
      ),
    );
  }

  List<int> generateList() {
    List<int> generated = [];
    for (int i = 0; i < box.length; i++) {
      Drinks current = box.getAt(i);
      if (current.week == week) {
        generated.add(i);
      }
    }
    print("GeneratedList in TimeLineWeek: " + generated.toString());
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
    print("TimeLineGrid initialized");
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
            child: GetraenkeListItem(index),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetailsTab(index),
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
    print("Current drink: " + currentDrink.toString());
    _image = currentDrink!.getImage(60.0, 90.0);
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
