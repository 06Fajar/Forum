import 'package:flutter/material.dart';
import 'package:flutter_application_1/komen_detail.dart';
import 'package:flutter_application_1/model/model_detail.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

class ForumDetail extends StatefulWidget {
  int idParent;

  ForumDetail({Key? key, required this.idParent}) : super(key: key);

  @override
  _ForumDetailState createState() => _ForumDetailState();
}

class _ForumDetailState extends State<ForumDetail> {
  TextEditingController _textController = TextEditingController();
  ModelDetail data = ModelDetail();

  final _boxUser = Hive.box('LocalStorage');

  @override
  void initState() {
    super.initState();
    getAPI();
  }

  void _handleSubmit(String text) {
    // Handle text submission here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Forum"),
      ),
      body: data.success == true
          ? Column(
              children: [
                Container(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(Icons.person_sharp),
                          ),
                          Text(data.parent?.nama ?? "-"),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Text(data.parent?.judul ?? "-"),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Wrap(
                          children: [
                            Text(
                              data.parent?.rincian ?? "-",
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.access_time_filled, size: 12),
                          Text(
                            data.parent?.createdAt != null
                                ? DateFormat('yyyy MM dd HH:mm')
                                    .format(data.parent!.createdAt!)
                                : "Date not available",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.comment, size: 12),
                          Text("${data.totalRows.toString()} Komentar",
                              style: TextStyle(fontSize: 12)),
                          SizedBox(width: 10),
                          Icon(Icons.report, size: 12),
                        ],
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.0,
                  color: Colors.black,
                  height: 0,
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: data.rows?.length ?? 0,
                    itemBuilder: (context, index) {
                      final row = data.rows?[index];
                      if (row != null) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => KomenDetail(
                                          idParent: data.rows![index].idForum!,
                                          replyTo: data.rows![index].idComment!,
                                        )));
                          },
                          child: Container(
                            padding: EdgeInsets.all(25),
                            child: Column(
                              children: [
                                Row(children: [
                                  Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Icon(Icons.person_sharp)),
                                  Text(row.nama ?? "-")
                                ]),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: buildMessage(
                                            true,
                                            row.text ?? "",
                                            MediaQuery.of(context).size.width *
                                                0.8)),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(children: [
                                  Icon(Icons.access_time, size: 12),
                                  Text(
                                      row.createdAt != null
                                          ? DateFormat('yyyy MM dd HH:mm')
                                              .format(row.createdAt!)
                                          : "Date not available",
                                      style: TextStyle(fontSize: 12)),
                                  SizedBox(width: 10),
                                  Icon(Icons.comment, size: 12),
                                  Text('${row.totalComment ?? 0} Komentar',
                                      style: TextStyle(fontSize: 12)),
                                  SizedBox(width: 10),
                                  Icon(Icons.report, size: 12)
                                ])

                                // leading: Icon(
                                //   Icons.account_circle_outlined,
                                //   size: 18,
                                // ),
                                // title: Text(row.nama ?? "-"),
                                // subtitle: Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     buildMessage(true, row.text ?? "",
                                //         MediaQuery.of(context).size.width * 0.8),
                                //     SizedBox(height: 10),
                                //     Row(
                                //       children: [
                                //         Icon(Icons.access_time, size: 12),
                                //         Text(
                                //             row.createdAt != null
                                //                 ? DateFormat('yyyy MM dd HH:mm')
                                //                     .format(row.createdAt!)
                                //                 : "Date not available",
                                //             style: TextStyle(fontSize: 12)),
                                //         SizedBox(width: 10),
                                //         Icon(Icons.comment, size: 12),
                                //         Text('${row.totalComment ?? 0} Komentar',
                                //             style: TextStyle(fontSize: 12)),
                                //         SizedBox(width: 10),
                                //         Icon(Icons.report, size: 12),
                                //       ],
                                //     ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.black,
                        thickness: 1,
                        height: 0,
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () => {
                                if (_textController.text.isNotEmpty)
                                  {
                                    getAPICreate(),
                                  }
                                else
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "teks tidak boleh kosong")))
                                  }
                              }),
                    ],
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> getAPI() async {
    var response = await http.post(
      Uri.parse('https://jakaset.jakarta.go.id/stagingaset/forum/comment/data'),
      headers: {'Authorization': _boxUser.get('token')},
      body: {
        'start': '0',
        'limit': '0',
        'id_forum': '${widget.idParent}',
        'replyTo': "0",
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        data = modelDetailFromJson(response.body);
      });
    }
  }

  Future<void> getAPICreate() async {
    var response = await http.post(
      Uri.parse(
          'https://jakaset.jakarta.go.id/stagingaset/forum/comment/create'),
      headers: {'Authorization': _boxUser.get('token')},
      body: {
        'creator': _boxUser.get('username'),
        'limit': '0',
        'id_forum': '${widget.idParent}',
        'replyTo': "0",
        'text': _textController.text
      },
    );

    if (response.statusCode == 200) {
      _textController.text = '';
      getAPI();
    }
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: ForumDetail(),
//   ));
// }

Widget buildMessage(bool isLeft, String message, double maxWidth) {
  return Align(
    alignment: isLeft ? Alignment.topLeft : Alignment.topRight,
    child: Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Text(message),
    ),
  );
}
