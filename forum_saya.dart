import 'package:flutter/material.dart';
import 'package:flutter_application_1/forum_klik.dart';
import 'package:flutter_application_1/model/forum_saya_model.dart';
import 'package:intl/intl.dart';

Widget MyForumPage(MyForumModel data) {
  return Column(
    children: [
      Expanded(
        child: ListView.builder(
          itemCount: data.rows?.length ?? 0,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ForumDetail(
                      idParent: data.rows![index].idForum!,
                    ),
                  ),
                );
              },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(Icons.person_sharp),
                          ),
                          Text(data.rows?[index].nama ?? "-"),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0, top: 8),
                            child: Text(
                              data.rows?[index].judul ?? "-",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8),
                        child: Wrap(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                            ),
                            Text(
                              data.rows?[index].rincian ?? "-",
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 8,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_filled, size: 12),
                            Text(
                              data.rows?[index].createdAt != null
                                  ? DateFormat('yyyy MM dd HH:mm').format(
                                      data.rows![index].createdAt!,
                                    )
                                  : "Date not available",
                              style: const TextStyle(fontSize: 12),
                            ),
                            const Icon(Icons.comment, size: 12),
                            Text(
                              "${data.rows?[index].totalComment} Komentar",
                              style: const TextStyle(fontSize: 12),
                            ),
                            const Icon(Icons.report, size: 12),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        margin: const EdgeInsets.all(8.0),
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}


