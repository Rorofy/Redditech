import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//import 'package:dio/dio.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redditech/globals.dart';

class RedditechLogin extends StatefulWidget {
  const RedditechLogin({Key? key}) : super(key: key);

  @override
  _RedditechLoginState createState() => _RedditechLoginState();
}

class _RedditechLoginState extends State<RedditechLogin> {
  // ignore: unused_field
  late InAppWebViewController _webViewController;
  String url = "";
  String userToken = '';
  double progress = 0;
  String? accessToken = '';
  String refreshToken = '';
  var last = subbSubreddits.length > 0 ? subbSubreddits.last : "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InAppWebView Reddit Login'),
      ),
      body: Container(
        child: Column(children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                    url: Uri.parse(
                        "https://www.reddit.com/api/v1/authorize.compact?client_id=p4by02qiM4_8Qi0_h-NHlg&response_type=code&state=placeholder&redirect_uri=http://localhost:8080&duration=permanent&scope=identity,edit,flair,history,modconfig,modflair,modlog,modposts,modwiki,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote,wikiedit,wikiread,account")),
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions()),
                onWebViewCreated: (InAppWebViewController controller) {
                  _webViewController = controller;
                },
                onUpdateVisitedHistory: (controller, url, refreshed) {
                  setState(() {
                    print(
                        "VISITOOOOOOOOOOOOOOOOOOOOOOOOOOR UPDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAATE");
                    this.url = url.toString();
                  });
                },
                onLoadStop: (controller, url) async {
                  if (this.url.toString().contains('localhost')) {
                    var queryResults = url?.queryParameters;
                    print(queryResults);
                    String? requestCode = queryResults?["code"];
                    Uri haha =
                        Uri.parse('https://www.reddit.com/api/v1/access_token');
                    final http.Response response = await http.post(haha,
                        headers: <String, String>{
                          'Authorization': 'Basic ' +
                              convert.base64Encode(convert.utf8
                                  .encode('p4by02qiM4_8Qi0_h-NHlg:')),
                          'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body:
                            "grant_type=authorization_code&code=$requestCode&redirect_uri=http://localhost:8080");
                    if (response.statusCode != 200) {
                      print("I FUCKEEEEEEEEEED UP!");
                      print(response.statusCode);
                      print("Does it match with the code just before?");
                      print(requestCode);
                    }
                    if (response.statusCode == 200) {
                      print("I got the tokens");
                      var decodedResponse = convert.jsonDecode(
                          convert.utf8.decode(response.bodyBytes)) as Map;
                      userToken = decodedResponse["access_token"];
                      refreshToken = decodedResponse["refresh_token"];
                      print("They are $userToken and $refreshToken");
                      print(dotenv.env['CACA']);
                      dotenv.env['USER_TOKEN'] = userToken;
                      dotenv.env['REFRESH_TOKEN'] = refreshToken;
                      print(dotenv.env.entries);
                      Uri basicUrl = Uri.https(
                          "oauth.reddit.com",
                          "/subreddits/mine/subscriber",
                          {"limit": '25', "raw_json": '1', "after": '$last'});
                      final header2 = {'Authorization': 'bearer $userToken'};
                      final http.Response response2 =
                          await http.get(basicUrl, headers: header2);
                      var data = convert
                          .jsonDecode(response2.body)!['data']!['children'];
                      data.forEach((element) =>
                          subbSubreddits.add(element['data']['display_name']));
                      print(subbSubreddits);
                      Navigator.pushNamed(context, '/general');
                    }
                  }
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
