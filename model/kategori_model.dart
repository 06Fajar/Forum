import 'dart:convert';

KategoriModelFromJson(String str) => KategoriModel.fromJson(json.decode(str));

String kategoriModelToJson(KategoriModel data) => json.encode(data.toJson());
class KategoriModel {
  bool? success;
  List<KategoriRows>? rows;
  int? totalRows;

  KategoriModel({
    this.success,
    this.rows,
    this.totalRows,
  });

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      success: json['success'],
      rows: List<KategoriRows>.from(json['rows']?.map((x) => KategoriRows.fromJson(x)) ?? []),
      totalRows: json['totalRows'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'rows': rows?.map((x) => x.toJson()).toList(),
      'totalRows': totalRows,
    };
  }
}

class KategoriRows {
  int? idKategori;
  String? kategori;

  KategoriRows({
    this.idKategori,
    this.kategori,
  });

  factory KategoriRows.fromJson(Map<String, dynamic> json) {
    return KategoriRows(
      idKategori: json['id_kategori'],
      kategori: json['kategori'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_kategori': idKategori,
      'kategori': kategori,
    };
  }
}
