import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redditech/globals.dart';

class Search extends SearchDelegate {
  late var subredditList;
  List<String> names = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () async {
          print(query + " Tester");
          String? token = dotenv.env['USER_TOKEN'];
          //final params = {
          //  'limit': '50',
          //  'q': '$query',
          //  'sort': 'relevance',
          //  't': 'all'
          //};
          final params = {
            'exact': 'false',
            'include_over_18': 'false',
            'include_unadvertisable': 'true',
            'query': "$query"
          };
          final header = {'Authorization': 'bearer $token'};
          //Uri basicUrl =
          //    Uri.https("oauth.reddit.com", "/r/$query/search", params);
          Uri basicUrl =
              Uri.https("oauth.reddit.com", "/api/search_reddit_names", params);
          final http.Response response = await http.get(
            basicUrl,
            headers: header,
          );
          print(response.statusCode);
          subredditList = convert
              .jsonDecode(convert.utf8.decode(response.bodyBytes)) as Map;
          //print(subredditList['names']);
          names = (subredditList['names'] as List)
              .map((item) => item as String)
              .toList();
          print(query);
          buildSuggestions(context);
          query = query; // Posez pas de question, ca fait marcher xD
          print('\n');
          print('\n');
          print('\n');
        },
      ),
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResult = "";

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];
    suggestionList.addAll(names);
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text(
              suggestionList[index],
            ),
            onTap: () async {
              selectedResult = suggestionList[index];
              showResults(context);
              dotenv.env['SELECT_RESULT'] = selectedResult;
              String? token = dotenv.env['USER_TOKEN'];
              final header = {'Authorization': 'bearer $token'};
              Uri basicUrl =
                  Uri.https("oauth.reddit.com", "/r/$selectedResult/about");
              final http.Response response = await http.get(
                basicUrl,
                headers: header,
              );
              var decodedResponse = convert
                  .jsonDecode(convert.utf8.decode(response.bodyBytes)) as Map;
              dotenv.env['SUBREDDIT_SUBS'] =
                  decodedResponse['data']['subscribers'].toString();
              String commPhoto = decodedResponse['data']['community_icon'];
              if (commPhoto.length == 0 || commPhoto.isEmpty) {
                commPhoto = decodedResponse['data']['header_img'];
                dotenv.env['SUB_USES_BANNER'] = 'true';
              }
              if (commPhoto.contains('?')) {
                commPhoto = commPhoto.replaceRange(
                    commPhoto.indexOf('?'), commPhoto.length, '');
              }
              dotenv.env['COMMUNITY_ICON'] =
                  decodedResponse['data']['community_icon'];
              dotenv.env['SUB_DESC'] =
                  decodedResponse['data']['public_description'];
              dotenv.env['COMMUNITY_ICON'] = commPhoto;
              print(dotenv.env['COMMUNITY_ICON']);
              dotenv.env['USER_IS_SUB'] =
                  decodedResponse['data']['user_is_subscriber'].toString();
              print("\n\nHere\n");
              print(decodedResponse['data']);
              print("///////////////////////////");
              subredditFeedHot = [];
              subredditFeedNew = [];
              subredditFeedRising = [];
              Navigator.pushNamedAndRemoveUntil(
                  context, '/subreddit', (_) => false);
            });
      },
    );
  }
}
