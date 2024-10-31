// ignore_for_file: unused_field
import 'package:flutter/material.dart';
import 'package:redditech/postDefinition.dart';
import 'package:redditech/postWidget.dart';
import 'package:redditech/search.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redditech/globals.dart';

class GeneralFeedPage extends StatefulWidget {
  const GeneralFeedPage({Key? key}) : super(key: key);

  @override
  _GeneralFeedPageState createState() => _GeneralFeedPageState();
}

//final params = {
//  'limit': '50',
//  'q': '$query',
//  'sort': 'relevance',
//  't': 'all'
//};
class _GeneralFeedPageState extends State<GeneralFeedPage> {
  //List<Post> feed = [];
  bool _loading = true;
  bool _error = false;
  String? token = dotenv.env['USER_TOKEN'];

  Future<void> fetchFeed(
      String subreddit, String filter, List<Post> feedToAttach) async {
    var header = {'Authorization': 'bearer $token'};
    final last = feedToAttach.length > 0 ? feedToAttach.last.fullname : "";
    final params = {
      'g': region == '' ? 'GLOBAL' : region,
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
    if (generalFeedHot.length < 50) {
      subbSubreddits.forEach((element) => {
            fetchFeed('$element', 'hot', generalFeedHot),
            fetchFeed('$element', 'rising', generalFeedRising),
            fetchFeed('$element', 'new', generalFeedNew)
          });
    }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Redditech"),
          automaticallyImplyLeading: false,
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
                  Uri basicUrl = Uri.https("oauth.reddit.com", "/api/v1/me");
                  final http.Response response =
                      await http.get(basicUrl, headers: header);
                  //print(response.body);
                  var userInfo = convert.jsonDecode(
                      convert.utf8.decode(response.bodyBytes)) as Map;
                  var data = userInfo['subreddit'];
                  userPhoto = data['icon_img'];
                  //print(userPhoto + "I AM HERE");
                  if (userPhoto.contains('?')) {
                    userPhoto = userPhoto.replaceRange(
                        userPhoto.indexOf('?'), userPhoto.length, '');
                  }
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
            // This is the first button, the hot posts
            Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: generalFeedHot.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == generalFeedHot.length - 5) {
                        List<Post> tmpList = [];
                        subbSubreddits.forEach(
                            (element) => {fetchFeed(element, 'hot', tmpList)});
                        generalFeedHot.addAll(tmpList);
                      }
                      return Column(children: <Widget>[
                        MyPostWidget(
                          '${generalFeedHot[index].title}',
                          '${generalFeedHot[index].user}',
                          '${generalFeedHot[index].body}',
                          '${generalFeedHot[index].isImage}',
                          '${generalFeedHot[index].image}',
                          '${generalFeedHot[index].sub}',
                        )
                      ]);
                    },
                  ),
                ),
              ],
            ),
            // This is the second button, the trending posts
            Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: generalFeedRising.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == generalFeedRising.length - 5) {
                        List<Post> tmpList2 = [];
                        subbSubreddits.forEach((element) =>
                            {fetchFeed(element, 'rising', tmpList2)});
                        generalFeedRising.addAll(tmpList2);
                      }
                      return Column(children: <Widget>[
                        MyPostWidget(
                          '${generalFeedRising[index].title}',
                          '${generalFeedRising[index].user}',
                          '${generalFeedRising[index].body}',
                          '${generalFeedRising[index].isImage}',
                          '${generalFeedRising[index].image}',
                          '${generalFeedRising[index].sub}',
                        )
                      ]);
                    },
                  ),
                ),
              ],
            ),
            // This is the third button, the new posts
            Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: generalFeedNew.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == generalFeedNew.length - 5) {
                        List<Post> tmpList3 = [];
                        subbSubreddits.forEach(
                            (element) => {fetchFeed(element, 'new', tmpList3)});
                        generalFeedNew.addAll(tmpList3);
                      }
                      return Column(children: <Widget>[
                        MyPostWidget(
                          '${generalFeedNew[index].title}',
                          '${generalFeedNew[index].user}',
                          '${generalFeedNew[index].body}',
                          '${generalFeedNew[index].isImage}',
                          '${generalFeedNew[index].image}',
                          '${generalFeedNew[index].sub}',
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
