import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/kategori_model.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class BuatForum extends StatefulWidget {
  const BuatForum({Key? key}) : super(key: key);

  @override
  State<BuatForum> createState() => _BuatForumState();
}

class _BuatForumState extends State<BuatForum> {
  String kategori = '', idKategori = '';
  File? selectedImage;
  KategoriModel? data;
  final _boxUser = Hive.box('LocalStorage');
  final ImagePicker _picker = ImagePicker();
  TextEditingController _rinciantextController = TextEditingController();
  TextEditingController _judultextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    kategori = 'e-RKBMD';
    idKategori = '0';
    getAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Buat Forum"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Kategori"),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: DropdownButtonFormField<KategoriRows>(
                items: data?.rows?.map<DropdownMenuItem<KategoriRows>>(
                        (KategoriRows value) {
                      return DropdownMenuItem(
                          value: value, child: Text(value.kategori!));
                    }).toList() ??
                    [],
                onChanged: (KategoriRows? value) {
                  if (value != null) {
                    setState(() {
                      kategori = value.kategori!;
                      idKategori = value.idKategori.toString();
                    });
                  }
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Judul"),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _judultextController,
              maxLength: 100,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Rincian"),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _rinciantextController,
              maxLength: 2000,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            Expanded(
              child: Card(
                color: Colors.grey[300],
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      selectedImage != null
                          ? Image.file(
                              selectedImage!,
                              width: double.infinity,
                              height: 254,
                              fit: BoxFit.cover,
                            )
                          : InkWell(
                              onTap: () {
                                _pickImage();
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.camera_alt_rounded,
                                    size: 40,
                                    color: Colors.black45,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Pilih Gambar",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                onPressed: () {
                  if (_judultextController.text.isNotEmpty &&
                      _rinciantextController.text.isNotEmpty) {
                    getAPICreateForum();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Teks tidak boleh kosong"),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  onPrimary: Colors.white,
                  minimumSize: Size(200, 50),
                ),
                child: Text(
                  "Kirim",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> getAPICreateForum() async {
    var response = await http.post(
      Uri.parse('https://jakaset.jakarta.go.id/stagingaset/forum/create'),
      headers: {'Authorization': _boxUser.get('token')},
      body: {
        'creator': _boxUser.get('username'),
        'id_kategori': idKategori,
        'rincian': _rinciantextController.text,
        'publish': '1',
        'sikonp': '0',
        'judul': _judultextController.text,
        'tags': "-"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      

      if (responseBody['success'] == true) {
        showDialogBerhasil();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Forum gagal terkirim"),
          ),
        );
      }
    } else {
      print("Unexpected status code: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }

  void showDialogBerhasil() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text(
                      'Informasi ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 48.0, bottom: 48.0),
                  child: Text(
                    'Forum berhasil dibuat',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.0, left: 0.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'Tutup',
                            style: TextStyle(fontSize: 14),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> getAPI() async {
    var response = await http.post(
        Uri.parse('https://jakaset.jakarta.go.id/stagingaset/forum/kategori'),
        headers: {'Authorization': _boxUser.get('token')});
    if (response.statusCode == 200) {
      setState(() {
        data = KategoriModelFromJson(response.body);
      });
    }
  }
}
