import 'package:flutter/material.dart';
import 'package:flutter_application_1/buatforum_page.dart';
import 'package:flutter_application_1/forum_klik.dart';
import 'package:flutter_application_1/forum_saya.dart';
import 'package:flutter_application_1/model/forum_model.dart';
import 'package:flutter_application_1/model/forum_saya_model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ForumPage extends StatefulWidget {
  ForumPage({Key? key}) : super(key: key);

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isSearchBarFocused = false;
  String searchQuery = "";
  List<RowForum> filteredData = [];
  MyForumModel dataSaya = MyForumModel();
  ForumModel data = ForumModel();
  final _boxUser = Hive.box('LocalStorage');
  int currentPage = 1;
  int pageSize = 10;
  bool isLoading = false;

  void filterData() {
    if (searchQuery.isEmpty) {
      filteredData = [];
    } else {
      filteredData = data.rows?.where((row) {
            return row.nama
                    ?.toLowerCase()
                    .contains(searchQuery.toLowerCase()) ??
                false;
          }).toList() ??
          [];
    }
  }

  @override
  void initState() {
    print("Initstate jalan");
    getAPI();
    getAPIMyForum();
    _tabController = TabController(length: 2, vsync: this);

    // Listen for scroll events to implement pagination
    ScrollController _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!isLoading) {
          // Reached the end of the list, load more data
          loadMoreData();
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _scrollController;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          isSearchBarFocused ? null : Icons.search,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isSearchBarFocused = !isSearchBarFocused;
                                if (!isSearchBarFocused) {
                                  searchQuery = "";
                                  filterData();
                                }
                              });
                            },
                            child: AbsorbPointer(
                              absorbing: isSearchBarFocused,
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value;
                                    filterData();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: isSearchBarFocused ? "" : "Search",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Semua Forum'),
              Tab(text: 'Forum Saya'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // "Semua Forum Content"
            Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: (filteredData.isNotEmpty
                          ? filteredData.length
                          : data.rows?.length ?? 0) + 1,
                      itemBuilder: (context, index) {
                        if (index == (filteredData.isNotEmpty
                                ? filteredData.length
                                : data.rows?.length ?? 0)) {
                          // Loading indicator at the end of the list
                          return Center(child: CircularProgressIndicator());
                        }
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ForumDetail(
                                        idParent: (filteredData.isNotEmpty
                                                ? filteredData[index].idForum
                                                : data.rows![index].idForum)!)));
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0, left: 16, right: 16),
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
                                        padding:
                                            EdgeInsets.only(left: 8.0, top: 8),
                                        child: Text(
                                          data.rows?[index].judul ?? "-",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 8),
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
                                        top: 8.0, bottom: 8),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time_filled,
                                            size: 12),
                                        Text(
                                            data.rows?[index].createdAt != null
                                                ? DateFormat('yyyy MM dd HH:mm')
                                                    .format(data.rows![index]
                                                        .createdAt!)
                                                : "Date not available",
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        const Icon(Icons.comment, size: 12),
                                        Text(
                                            "${data.rows?[index].totalComment} Komentar",
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        const Icon(Icons.report, size: 12)
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    margin: const EdgeInsets.all(8.0),
                                    color: Colors.grey.shade300,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    onRefresh: () async {
                      await refreshData();
                    },
                  ),
                ),
              ],
            ),
            // "Forum Saya Content"
            MyForumPage(dataSaya)
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            awaitReturnValue(context);
          },
          label: Text("Buat Forum"),
          icon: Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void awaitReturnValue(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BuatForum(),
        ));
    getAPI();
  }

  Future<void> getAPIMyForum() async {
    var response = await http.post(
        Uri.parse('https://jakaset.jakarta.go.id/stagingaset/forum/myforum'),
        headers: {
          'Authorization': _boxUser.get('token')
        },
        body: {
          'start': '0',
          'limit': '10',
          'kata': "",
          'creator': _boxUser.get('username'),
          'id_kategori': "",
          'date': "",
          'sikonp': "0"
        });

    print(response.body.toString());
    if (response.statusCode == 200) {
      setState(() {
        dataSaya = myForumModelFromJson(response.body);
      });
    }
  }

  Future<void> getAPI() async {
    var response = await http.post(
      Uri.parse('https://jakaset.jakarta.go.id/stagingaset/forum/data'),
      headers: {'Authorization': _boxUser.get('token')},
      body: {
        'start': '0',
        'limit': '10',
        'kata': "",
        'id_kategori': "",
        'date': "",
      },
    );

    print(response.body.toString());
    if (response.statusCode == 200) {
      setState(() {
        data = forumModelFromJson(response.body);
      });

      if (isSearchBarFocused && searchQuery.isNotEmpty) {
        filterData();
      }

      print('api berhasil');
    }
  }

  Future<void> loadMoreData() async {
    setState(() {
      isLoading = true;
    });

    // Fetch more data with pagination
    var response = await http.post(
      Uri.parse('https://jakaset.jakarta.go.id/stagingaset/forum/data'),
      headers: {'Authorization': _boxUser.get('token')},
      body: {
        'start': (currentPage * pageSize).toString(),
        'limit': pageSize.toString(),
        'kata': "",
        'id_kategori': "",
        'date': "",
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        List<RowForum> newData = forumModelFromJson(response.body).rows ?? [];
        data.rows?.addAll(newData);
        currentPage++;
        isLoading = false;
      });
    }
  }

  Future<void> refreshData() async {
    currentPage = 1;
    await getAPI();
    if (isSearchBarFocused && searchQuery.isNotEmpty) {
      filterData();
    }
  }
}
