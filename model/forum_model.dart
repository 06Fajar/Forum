import 'dart:convert';

ForumModel forumModelFromJson(String str) => ForumModel.fromJson(json.decode(str));

String forumModelToJson(ForumModel data) => json.encode(data.toJson());

class ForumModel {
  bool? success;
  List<RowForum>? rows;
  int? totalRows;
  String? urlmedia;

  ForumModel({
    this.success,
    this.rows,
    this.totalRows,
    this.urlmedia,
  });

  factory ForumModel.fromJson(Map<String, dynamic> json) => ForumModel(
        success: json["success"],
        rows: List<RowForum>.from(json["rows"].map((x) => RowForum.fromJson(x))),
        totalRows: json["totalRows"],
        urlmedia: json["urlmedia"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "rows": List<dynamic>.from(rows!.map((x) => x.toJson())),
        "totalRows": totalRows,
        "urlmedia": urlmedia,
      };
}

class RowForum {
  String? nmKategori;
  int? idForum;
  int? idKategori;
  String? judul;
  String? rincian;
  String? publish;
  String? media;
  String? creator;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? nama;
  int? totalComment;
  bool? myForum;

  RowForum({
    this.nmKategori,
    this.idForum,
    this.idKategori,
    this.judul,
    this.rincian,
    this.publish,
    this.media,
    this.creator,
    this.createdAt,
    this.updatedAt,
    this.nama,
    this.totalComment,
    this.myForum,
  });

  factory RowForum.fromJson(Map<String, dynamic> json) => RowForum(
        nmKategori: json["nm_kategori"],
        idForum: json["id_forum"],
        idKategori: json["id_kategori"],
        judul: json["judul"],
        rincian: json["rincian"],
        publish: json["publish"],
        media: json["media"],
        creator: json["creator"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        nama: json["nama"],
        totalComment: json["totalComment"],
        myForum: json["myForum"],
      );

  Map<String, dynamic> toJson() => {
        "nm_kategori": nmKategori,
        "id_forum": idForum,
        "id_kategori": idKategori,
        "judul": judul,
        "rincian": rincian,
        "publish": publish,
        "media": media,
        "creator": creator,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "nama": nama,
        "totalComment": totalComment,
        "myForum": myForum,
      };
}
