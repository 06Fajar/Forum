import 'dart:convert';

ModelDetail modelDetailFromJson(String str) => ModelDetail.fromJson(json.decode(str));

String modelDetailToJson(ModelDetail data) => json.encode(data.toJson());

class ModelDetail {
    bool? success;
    Parent? parent;
    List<Rows>? rows;
    int? totalRows;
    String? urlmedia;

    ModelDetail({
        this.success,
        this.parent,
        this.rows,
        this.totalRows,
        this.urlmedia,
    });

    factory ModelDetail.fromJson(Map<String, dynamic> json) => ModelDetail(
        success: json["success"],
        parent: Parent.fromJson(json["parent"]),
        rows: List<Rows>.from(json["rows"].map((x) => Rows.fromJson(x))),
        totalRows: json["totalRows"],
        urlmedia: json["urlmedia"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "parent": parent?.toJson(),
        "rows": List<dynamic>.from(rows!.map((x) => x.toJson())),
        "totalRows": totalRows,
        "urlmedia": urlmedia,
    };
}

class Parent {
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
    String? sikonp;
    String? nama;

    Parent({
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
        this.sikonp,
        this.nama,
    });

    factory Parent.fromJson(Map<String, dynamic> json) => Parent(
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
        sikonp: json["sikonp"],
        nama: json["nama"],
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "sikonp": sikonp,
        "nama": nama,
    };
}

class Rows {
    int? idComment;
    int? replyTo;
    int? idForum;
    String? text;
    String? creator;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? publish;
    String? nama;
    int? totalComment;

    Rows({
        this.idComment,
        this.replyTo,
        this.idForum,
        this.text,
        this.creator,
        this.createdAt,
        this.updatedAt,
        this.publish,
        this.nama,
        this.totalComment,
    });

    factory Rows.fromJson(Map<String, dynamic> json) => Rows(
        idComment: json["id_comment"],
        replyTo: json["replyTo"],
        idForum: json["id_forum"],
        text: json["text"],
        creator: json["creator"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        publish: json["publish"],
        nama: json["nama"],
        totalComment: json["totalComment"],
    );

    Map<String, dynamic> toJson() => {
        "id_comment": idComment,
        "replyTo": replyTo,
        "id_forum": idForum,
        "text": text,
        "creator": creator,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "publish": publish,
        "nama": nama,
        "totalComment": totalComment,
    };
}