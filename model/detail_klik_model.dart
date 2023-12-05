import 'dart:convert';

KlikModel klikModelFromJson(String str) => KlikModel.fromJson(json.decode(str));

String modelDetailToJson(KlikModel data) => json.encode(data.toJson());

class KlikModel {
  bool? success;
  Parent? parent;
  List<Parent>? rows;
  int? totalRows;
  String? urlmedia;

  KlikModel({
    this.success,
    this.parent,
    this.rows,
    this.totalRows,
    this.urlmedia,
  });

  factory KlikModel.fromJson(Map<String, dynamic> json) {
    return KlikModel(
      success: json['success'],
      parent: Parent.fromJson(json['parent']),
      rows: List<Parent>.from(json['rows']?.map((x) => Parent.fromJson(x))),
      totalRows: json['totalRows'],
      urlmedia: json['urlmedia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'parent': parent?.toJson(),
      'rows': rows?.map((x) => x.toJson()).toList(),
      'totalRows': totalRows,
      'urlmedia': urlmedia,
    };
  }
}

class Parent {
  int? idComment;
  int? replyTo;
  int? idForum;
  String? text;
  String? creator;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? publish;
  String? rincian;
  String? nama;
  int? totalComment;

  Parent({
    this.idComment,
    this.replyTo,
    this.idForum,
    this.text,
    this.creator,
    this.createdAt,
    this.updatedAt,
    this.publish,
    this.rincian,
    this.nama,
    this.totalComment,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      idComment: json['idComment'],
      replyTo: json['replyTo'],
      idForum: json['idForum'],
      text: json['text'],
      creator: json['creator'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      publish: json['publish'],
      rincian: json['rincian'],
      nama: json['nama'],
      totalComment: json['totalComment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idComment': idComment,
      'replyTo': replyTo,
      'idForum': idForum,
      'text': text,
      'creator': creator,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'publish': publish,
      'rincian': rincian,
      'nama': nama,
      'totalComment': totalComment,
    };
  }
}
