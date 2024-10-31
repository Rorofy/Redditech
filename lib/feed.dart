// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redditech/postDefinition.dart';

class RedditechFeed {
  List<Post> _feed = [];
  bool _loading = true;
  bool _error = false;

  Future<void> fetchFeedDefault() async {
    final last = _feed.length > 0 ? _feed.last.fullname : "";
    final params = {'after': last};
    final uri = Uri.https('api.reddit.com', '/best', params);
    final response = await http.get(uri);
    List<Post> postList =
        Post.parseList(json.decode(response.body)!['data']!['children']);
    if (response.statusCode == 200) {
      _loading = false;
      _feed.addAll(postList);
    } else {
      _error = true;
      print(response.statusCode);
    }
  }

  void initState() {
    initState();
    fetchFeedDefault();
  }

  List<Post> getFeed() {
    fetchFeedDefault();
    return _feed;
  }
}
