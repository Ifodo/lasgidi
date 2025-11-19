// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Welcome2> welcomeFromJson(String str) => List<Welcome2>.from(json.decode(str).map((x) => Welcome2.fromJson(x)));

String welcomeToJson(List<Welcome2> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Welcome2 {
  Welcome2({
    this.id,
    this.v,
    this.welcomeId,
    this.dayOfWeek,
    this.businessLocation,
    this.programEndTime,
    this.programStartTime,
    this.end,
    this.start,
    this.oapId,
    this.title,
  });

  String? id;
  int? v;
  int? welcomeId;
  String? dayOfWeek;
  String? businessLocation;
  DateTime? programEndTime;
  DateTime? programStartTime;
  String? end;
  String? start;
  String? oapId;
  String? title;

  factory Welcome2.fromJson(Map<String, dynamic> json) => Welcome2(
    id: json["_id"],
    v: json["__v"],
    welcomeId: json["id"],
    dayOfWeek: json["dayOfWeek"],
    businessLocation: json["businessLocation"],
    programEndTime: DateTime.parse(json["programEndTime"]),
    programStartTime: DateTime.parse(json["programStartTime"]),
    end: json["end"],
    start: json["start"],
    oapId: json["oapID"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "__v": v,
    "id": welcomeId,
    "dayOfWeek": dayOfWeek,
    "businessLocation": businessLocation,
    "programEndTime": programEndTime!.toIso8601String(),
    "programStartTime": programStartTime!.toIso8601String(),
    "end": end,
    "start": start,
    "oapID": oapId,
    "title": title,
  };
}
