// To parse this JSON data, do
//
//     final calenderPostModel = calenderPostModelFromJson(jsonString);

import 'dart:convert';

CalenderPostModel calenderPostModelFromJson(String str) => CalenderPostModel.fromJson(json.decode(str));

String calenderPostModelToJson(CalenderPostModel data) => json.encode(data.toJson());

class CalenderPostModel {
  bool? success;
  String? errorMsg;
  List<Datum>? data;

  CalenderPostModel({
    this.success,
    this.errorMsg,
    this.data,
  });

  factory CalenderPostModel.fromJson(Map<String, dynamic> json) => CalenderPostModel(
    success: json["success"],
    errorMsg: json["errorMsg"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "errorMsg": errorMsg,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  DateTime? date;
  Month? month;
  String? tithi;
  String? suryoday;
  String? suryast;
  String? navkarshi;
  String? porsi;
  String? saadhporsi;

  Datum({
    this.date,
    this.month,
    this.tithi,
    this.suryoday,
    this.suryast,
    this.navkarshi,
    this.porsi,
    this.saadhporsi,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    month: monthValues.map[json["month"]]!,
    tithi: json["tithi"],
    suryoday: json["suryoday"],
    suryast: json["Suryast"],
    navkarshi: json["navkarshi"],
    porsi: json["porsi"],
    saadhporsi: json["saadhporsi"],
  );

  Map<String, dynamic> toJson() => {
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "month": monthValues.reverse[month],
    "tithi": tithi,
    "suryoday": suryoday,
    "Suryast": suryast,
    "navkarshi": navkarshi,
    "porsi": porsi,
    "saadhporsi": saadhporsi,
  };
}

enum Month {
  AMBITIOUS,
  CUNNING,
  EMPTY,
  FLUFFY,
  HILARIOUS,
  INDECENT,
  INDIGO,
  MONTH,
  PURPLE,
  STICKY,
  TENTACLED
}

final monthValues = EnumValues({
  "શ્રાવણ": Month.AMBITIOUS,
  "ભાદરવા": Month.CUNNING,
  "કારતક": Month.EMPTY,
  "મહા": Month.FLUFFY,
  "અષાઢ": Month.HILARIOUS,
  "નિજ જેઠ": Month.INDECENT,
  "અધિક જેઠ": Month.INDIGO,
  "માગશર": Month.MONTH,
  "પોષ": Month.PURPLE,
  "ચૈત્ર": Month.STICKY,
  "ફાગણ": Month.TENTACLED
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
