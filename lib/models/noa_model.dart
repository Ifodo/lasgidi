// To parse this JSON data, do
//
//     final nowAndNext = nowAndNextFromJson(jsonString);

import 'dart:convert';

NowAndNext nowAndNextFromJson(String str) => NowAndNext.fromJson(json.decode(str));

String nowAndNextToJson(NowAndNext data) => json.encode(data.toJson());

class NowAndNext {
  ProgramInfo? nowOnAir;
  ProgramInfo? upNext;

  NowAndNext({
    this.nowOnAir,
    this.upNext,
  });

  factory NowAndNext.fromJson(Map<String, dynamic> json) => NowAndNext(
    nowOnAir: json["nowOnAir"] != null ? ProgramInfo.fromJson(json["nowOnAir"]) : null,
    upNext: json["upNext"] != null ? ProgramInfo.fromJson(json["upNext"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "nowOnAir": nowOnAir?.toJson(),
    "upNext": upNext?.toJson(),
  };
}

class ProgramInfo {
  String? programName;
  ProgramDuration? duration;
  List<String>? oaps;
  String? image;

  ProgramInfo({
    this.programName,
    this.duration,
    this.oaps,
    this.image,
  });

  factory ProgramInfo.fromJson(Map<String, dynamic> json) => ProgramInfo(
    programName: json["programName"],
    duration: json["duration"] != null ? ProgramDuration.fromJson(json["duration"]) : null,
    oaps: json["oaps"] != null ? List<String>.from(json["oaps"].map((x) => x)) : null,
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "programName": programName,
    "duration": duration?.toJson(),
    "oaps": oaps != null ? List<dynamic>.from(oaps!.map((x) => x)) : null,
    "image": image,
  };
}

class ProgramDuration {
  String? start;
  String? end;

  ProgramDuration({
    this.start,
    this.end,
  });

  factory ProgramDuration.fromJson(Map<String, dynamic> json) => ProgramDuration(
    start: json["start"],
    end: json["end"],
  );

  Map<String, dynamic> toJson() => {
    "start": start,
    "end": end,
  };
}

// Keep old Welcome class for backward compatibility if needed
class Welcome {
  dynamic schedule;
  dynamic oapData;
  dynamic nextProgram;

  Welcome({
    this.schedule,
    this.oapData,
    this.nextProgram,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    schedule: json["schedule"],
    oapData: json["oapData"],
    nextProgram: json["nextProgram"],
  );

  Map<String, dynamic> toJson() => {
    "schedule": schedule,
    "oapData": oapData,
    "nextProgram": nextProgram,
  };
}

class NextProgram {
  String id;
  int v;
  int nextProgramId;
  String dayOfWeek;
  String businessLocation;
  DateTime programEndTime;
  DateTime programStartTime;
  String end;
  String start;
  String oapId;
  String title;

  NextProgram({
    required this.id,
    required this.v,
    required this.nextProgramId,
    required this.dayOfWeek,
    required this.businessLocation,
    required this.programEndTime,
    required this.programStartTime,
    required this.end,
    required this.start,
    required this.oapId,
    required this.title,
  });

  factory NextProgram.fromJson(Map<String, dynamic> json) => NextProgram(
    id: json["_id"],
    v: json["__v"],
    nextProgramId: json["id"],
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
    "id": nextProgramId,
    "dayOfWeek": dayOfWeek,
    "businessLocation": businessLocation,
    "programEndTime": programEndTime.toIso8601String(),
    "programStartTime": programStartTime.toIso8601String(),
    "end": end,
    "start": start,
    "oapID": oapId,
    "title": title,
  };
}