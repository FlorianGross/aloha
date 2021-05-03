import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'Classification/Utility.dart';

part 'Drinks.g.dart';

@HiveType(typeId: 0)
class Drinks extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? uri;
  @HiveField(2)
  int? date;
  @HiveField(3)
  double? volume;
  @HiveField(4)
  double? volumepart;
  @HiveField(5)
  int? session;
  @HiveField(6)
  int? week;

  Drinks(
      {this.name,
      this.uri,
      this.date,
      this.volume,
      this.volumepart,
      this.session,
      this.week});

  SizedBox getImage(double height, double width) {
    if (uri != null) {
      print("Image: Notnull");
      return SizedBox(
        child: Utility.imageFromBase64String(uri!),
        height: height,
        width: width,
      );
    } else {
      print("Image: Null");
      return SizedBox(
        child: Icon(Icons.camera),
        height: height,
        width: width,
      );
    }
  }

  double getSE() {
    double se = (volume! * (volumepart! / 1000) * 0.8) / 2;
    return se;
  }

  DateTime getDate(){
    return DateTime.fromMillisecondsSinceEpoch(date!);
  }

  String toString() {
    return "Getränke{" +
        "Name = " +
        name.toString() +
        " , Bitmap = " +
        "Bitmap" +
        " , date = " +
        date.toString() +
        " , volume = " +
        volume.toString() +
        " , volumePart = " +
        volumepart.toString() +
        " , session = " +
        session.toString() +
        " , week = " +
        week.toString() +
        "}";
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uri': uri,
      'date': date,
      'volume': volume,
      'volumePart': volumepart,
      'session': session,
      'week': week,
    };
  }
}
