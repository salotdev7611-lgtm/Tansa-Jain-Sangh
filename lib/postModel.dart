// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  bool? success;
  String? errorMsg;
  List<Datum>? data;

  PostModel({
    this.success,
    this.errorMsg,
    this.data,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
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
  String? id;
  String? type;
  PostedBy? postedBy;
  String? content;
  DateTime? datetime;
  String? likes;
  String? comments;
  bool? hasLiked;
  bool? hasBookmarked;

  Datum({
    this.id,
    this.type,
    this.postedBy,
    this.content,
    this.datetime,
    this.likes,
    this.comments,
    this.hasLiked,
    this.hasBookmarked,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    type: json["type"],
    postedBy: json["posted_by"] == null ? null : PostedBy.fromJson(json["posted_by"]),
    content: json["content"],
    datetime: json["datetime"] == null ? null : DateTime.parse(json["datetime"]),
    likes: json["likes"],
    comments: json["comments"],
    hasLiked: json["has_liked"],
    hasBookmarked: json["has_bookmarked"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "posted_by": postedBy?.toJson(),
    "content": content,
    "datetime": datetime?.toIso8601String(),
    "likes": likes,
    "comments": comments,
    "has_liked": hasLiked,
    "has_bookmarked": hasBookmarked,
  };
}

class PostedBy {
  String? id;
  String? profileImg;
  String? name;
  String? surname;
  String? gender;
  String? bornInSameFamily;
  String? mobileNo;
  DateTime? dob;
  String? email;
  String? carrierType;
  String? profession;
  String? subProfession;

  PostedBy({
    this.id,
    this.profileImg,
    this.name,
    this.surname,
    this.gender,
    this.bornInSameFamily,
    this.mobileNo,
    this.dob,
    this.email,
    this.carrierType,
    this.profession,
    this.subProfession,
  });

  factory PostedBy.fromJson(Map<String, dynamic> json) => PostedBy(
    id: json["id"],
    profileImg: json["profile_img"],
    name: json["name"],
    surname: json["surname"],
    gender: json["gender"],
    bornInSameFamily: json["born_in_same_family"],
    mobileNo: json["mobile_no"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    email: json["email"],
    carrierType: json["carrier_type"],
    profession: json["profession"],
    subProfession: json["sub_profession"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "profile_img": profileImg,
    "name": name,
    "surname": surname,
    "gender": gender,
    "born_in_same_family": bornInSameFamily,
    "mobile_no": mobileNo,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "email": email,
    "carrier_type": carrierType,
    "profession": profession,
    "sub_profession": subProfession,
  };
}
