// To parse this JSON data, do
//
//     final responseCheck = responseCheckFromMap(jsonString);

import 'dart:convert';

ResponseCheck responseCheckFromMap(String str) =>
    ResponseCheck.fromMap(json.decode(str));

String responseCheckToJson(ResponseCheck data) => json.encode(data.toMap());

class ResponseCheck {
  ResponseCheck({
    this.success,
    this.msg,
    this.message,
    this.sql,
  });

  bool? success;
  String? msg;
  String? message;
  List<dynamic>? sql;

  factory ResponseCheck.fromMap(Map<String, dynamic> json) => ResponseCheck(
        success: json["success"],
        msg: json["msg"],
        message: json["message"],
        sql: List<dynamic>.from(json["sql"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "msg": msg,
        "message": message,
        "sql": List<dynamic>.from(sql!.map((x) => x)),
      };
}
