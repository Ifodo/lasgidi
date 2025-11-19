// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<WelcomeGallery> welcomeFromJson(String str) => List<WelcomeGallery>.from(json.decode(str).map((x) => WelcomeGallery.fromJson(x)));

String welcomeToJson(List<WelcomeGallery> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WelcomeGallery {
  WelcomeGallery({
    this.id,
    this.oapFullName,
    this.oapPersonalityName,
    this.gender,
    this.profile,
    this.oapVideo,
    this.oapPicture,
    this.businessLocation,
    this.v,
    this.profileActive,
  });

  String? id;
  String? oapFullName;
  String? oapPersonalityName;
  String? gender;
  String? profile;
  String? oapVideo;
  String? oapPicture;
  String? businessLocation;
  int? v;
  String? profileActive;

  factory WelcomeGallery.fromJson(Map<String, dynamic> json) => WelcomeGallery(
    id: json["_id"],
    oapFullName: json["oapFullName"],
    oapPersonalityName: json["oapPersonalityName"],
    gender: json["gender"],
    profile: json["profile"],
    oapVideo: json["oapVideo"],
    oapPicture: json["oapPicture"],
    businessLocation: json["businessLocation"],
    v: json["__v"],
    profileActive: json["profileActive"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "oapFullName": oapFullName,
    "oapPersonalityName": oapPersonalityName,
    "gender": gender,
    "profile": profile,
    "oapVideo": oapVideo,
    "oapPicture": oapPicture,
    "businessLocation": businessLocation,
    "__v": v,
    "profileActive": profileActive,
  };

  /*Map<String, dynamic> toJson() => {
    "_id": id,
    "oapFullName": oapFullName,
    "oapPersonalityName": oapPersonalityName,
    "gender": genderValues.reverse[gender],
    "profile": profile,
    "oapVideo": oapVideo,
    "oapPicture": oapPicture,
    "businessLocation": businessLocationValues.reverse[businessLocation],
    "__v": v,
    "profileActive": profileActiveValues.reverse[profileActive],
  };*/
}

/*enum BusinessLocation { TRAFFIC }

final businessLocationValues = EnumValues({
  "Traffic": BusinessLocation.TRAFFIC
});

enum Gender { MALE, FEMALE }

final genderValues = EnumValues({
  "Female": Gender.FEMALE,
  "Male": Gender.MALE
});

enum ProfileActive { YES }

final profileActiveValues = EnumValues({
  "yes": ProfileActive.YES
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}*/
