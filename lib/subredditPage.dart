// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:redditech/postWidget.dart';
import 'package:redditech/search.dart';
import 'package:redditech/subredditHeader.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redditech/globals.dart';
import 'package:redditech/postDefinition.dart';

class SubredditPage extends StatefulWidget {
  const SubredditPage({Key? key}) : super(key: key);

  @override
  _SubredditPageState createState() => _SubredditPageState();
}

class _SubredditPageState extends State<SubredditPage> {
  String? token = dotenv.env['USER_TOKEN'];
  bool _loading = true;
  bool _error = false;

  Future<void> fetchFeed(
      String subreddit, String filter, List<Post> feedToAttach) async {
    var header = {'Authorization': 'bearer $token'};
    final last = feedToAttach.length > 0 ? feedToAttach.last.fullname : "";
    final params = {
      'g': "GLOBAL",
      'after': '$last',
      'limit': '25',
      "raw_json": "1"
    };
    final uri = Uri.https('oauth.reddit.com', '/r/$subreddit/$filter', params);
    final response = await http.get(uri, headers: header);
    List<Post> postList = Post.parseList(
        convert.json.decode(response.body)!['data']!['children']);

    if (response.statusCode == 200) {
      setState(() {
        _loading = false;
        feedToAttach.addAll(postList);
      });
    } else {
      _error = true;
    }
  }

  //@override
  //void initState() {
  //  super.initState();
  //  fetchFeed('gaming', 'hot');
  //  print(feed);
  //}

  @override
  Widget build(BuildContext context) {
    if (subredditFeedHot.length < 50) {
      fetchFeed(
          dotenv.env['SELECT_RESULT'].toString(), 'hot', subredditFeedHot);
      fetchFeed(dotenv.env['SELECT_RESULT'].toString(), 'rising',
          subredditFeedRising);
      fetchFeed(
          dotenv.env['SELECT_RESULT'].toString(), 'new', subredditFeedNew);
    }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Redditech"),
          leading: GestureDetector(
              child: InkWell(
            onTap: () {
              generalFeedHot = [];
              generalFeedNew = [];
              generalFeedRising = [];
              Navigator.pushNamedAndRemoveUntil(
                  context, '/general', (_) => false);
            },
            child: Icon(Icons.arrow_back),
          )),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: Search());
                  },
                  icon: Icon(
                    Icons.search,
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () async {
                  String? token = dotenv.env['USER_TOKEN'];
                  final header = {'Authorization': 'bearer $token'};
                  var params = {"raw_json": '1'};
                  Uri basicUrl =
                      Uri.https("oauth.reddit.com", "/api/v1/me", params);
                  final http.Response response = await http.get(
                    basicUrl,
                    headers: header,
                  );
                  print(response.statusCode);
                  var userInfo = convert.jsonDecode(
                      convert.utf8.decode(response.bodyBytes)) as Map;
                  var data = userInfo['subreddit'];
                  userPhoto = data['icon_img'];
                  if (userPhoto.contains('?')) {
                    userPhoto = userPhoto.replaceRange(
                        userPhoto.indexOf('?'), userPhoto.length, '');
                  }
                  Tab(icon: Icon(Icons.fiber_new_outlined));
                  Tab(icon: Icon(Icons.local_fire_department_outlined));
                  Tab(icon: Icon(Icons.lightbulb_outlined));
                  //print(data);
                  userName = data['display_name'];
                  userProfileDesc = data['description'] == ""
                      ? 'No description'
                      : data['description'];
                  Navigator.pushNamed(context, '/profile');
                },
                icon: Icon(
                  Icons.person,
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.local_fire_department_outlined)),
              Tab(icon: Icon(Icons.trending_up_outlined)),
              Tab(icon: Icon(Icons.auto_awesome_outlined)),
            ],
          ),
        ),
        body: Center(
          child: TabBarView(children: [
            Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: subredditFeedHot.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) return SubredditHeader();
                      if (index == subredditFeedHot.length - 5) {
                        fetchFeed(dotenv.env['SELECT_RESULT'].toString(), 'hot',
                            subredditFeedHot);
                      }
                      return Column(children: <Widget>[
                        MyPostWidget(
                          '${subredditFeedHot[index - 1].title}',
                          '${subredditFeedHot[index - 1].user}',
                          '${subredditFeedHot[index - 1].body}',
                          '${subredditFeedHot[index - 1].isImage}',
                          '${subredditFeedHot[index - 1].image}',
                          '${subredditFeedHot[index - 1].sub}',
                        )
                      ]);
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: subredditFeedHot.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) return SubredditHeader();
                      if (index == subredditFeedRising.length - 5) {
                        fetchFeed(dotenv.env['SELECT_RESULT'].toString(),
                            'rising', subredditFeedRising);
                      }
                      return Column(children: <Widget>[
                        MyPostWidget(
                          '${subredditFeedRising[index - 1].title}',
                          '${subredditFeedRising[index - 1].user}',
                          '${subredditFeedRising[index - 1].body}',
                          '${subredditFeedRising[index - 1].isImage}',
                          '${subredditFeedRising[index - 1].image}',
                          '${subredditFeedRising[index - 1].sub}',
                        )
                      ]);
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: subredditFeedHot.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) return SubredditHeader();
                      if (index == subredditFeedNew.length - 5) {
                        fetchFeed(dotenv.env['SELECT_RESULT'].toString(), 'new',
                            subredditFeedNew);
                      }
                      return Column(children: <Widget>[
                        MyPostWidget(
                          '${subredditFeedNew[index - 1].title}',
                          '${subredditFeedNew[index - 1].user}',
                          '${subredditFeedNew[index - 1].body}',
                          '${subredditFeedNew[index - 1].isImage}',
                          '${subredditFeedNew[index - 1].image}',
                          '${subredditFeedNew[index - 1].sub}',
                        )
                      ]);
                    },
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
