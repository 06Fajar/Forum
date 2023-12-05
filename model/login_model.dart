import 'dart:convert';

LoginData loginDataFromMap(String str) => LoginData.fromMap(json.decode(str));
String loginDataToMap(LoginData data) => json.encode(data.toMap());

class LoginData {
  LoginData({
    this.success,
    this.msg,
    this.token,
    this.refreshToken,
    this.user,
    this.sql,
  });

  bool? success;
  String? msg;
  String? token;
  String? refreshToken;
  User? user;
  List<dynamic>? sql;

  factory LoginData.fromMap(Map<String, dynamic> json) => LoginData(
        success: json["success"],
        msg: json["msg"],
        token: json["token"],
        refreshToken: json["refresh_token"],
        user: User.fromMap(json["user"]),
        sql: List<dynamic>.from(json["sql"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "msg": msg,
        "token": token,
        "refresh_token": refreshToken,
        "user": user?.toMap(),
        "sql": List<dynamic>.from(sql!.map((x) => x)),
      };
}

class User {
  User({
    this.id,
    this.role,
    this.username,
    this.nama,
    this.telp,
    this.nip,
    this.nrk,
    this.password,
    this.active,
    this.passwordChanged,
    this.lastLogin,
    this.groupId,
    this.groupName,
    this.groupDesc,
    this.levelId,
    this.slugRole,
    this.kolok,
    this.kolokskpd,
    this.skpd,
    this.namaA,
    this.nipA,
    this.urut,
    this.internal,
  });

  String? id;
  String? role;
  String? username;
  String? nama;
  String? telp;
  String? nip;
  String? nrk;
  String? password;
  String? active;
  String? passwordChanged;
  String? lastLogin;
  int? groupId;
  String? groupName;
  String? groupDesc;
  String? levelId;
  String? slugRole;
  String? kolok;
  String? kolokskpd;
  String? skpd;
  String? namaA;
  String? nipA;
  String? urut;
  bool? internal;

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        role: json["role"],
        username: json["username"],
        nama: json["nama"],
        telp: json["telp"],
        nip: json["nip"],
        nrk: json["nrk"],
        password: json["password"],
        active: json["active"],
        passwordChanged: json["password_changed"],
        lastLogin: json["last_login"],
        groupId: json["group_id"],
        groupName: json["group_name"],
        groupDesc: json["group_desc"],
        levelId: json["level_id"],
        slugRole: json["slug_role"],
        kolok: json["kolok"],
        kolokskpd: json["kolokskpd"],
        skpd: json["skpd"],
        namaA: json["nama_a"],
        nipA: json["nip_a"],
        urut: json["urut"],
        internal: json["internal"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "role": role,
        "username": username,
        "nama": nama,
        "telp": telp,
        "nip": nip,
        "nrk": nrk,
        "password": password,
        "active": active,
        "password_changed": passwordChanged,
        "last_login": lastLogin,
        "group_id": groupId,
        "group_name": groupName,
        "group_desc": groupDesc,
        "level_id": levelId,
        "slug_role": slugRole,
        "kolok": kolok,
        "kolokskpd": kolokskpd,
        "skpd": skpd,
        "nama_a": namaA,
        "nip_a": nipA,
        "urut": urut,
        "internal": internal,
      };
}
