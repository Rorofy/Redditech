import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redditech/globals.dart';

class SubredditHeader extends StatefulWidget {
  SubredditHeader({
    Key? key,
  }) : super(key: key);

  @override
  _SubredditHeaderState createState() => _SubredditHeaderState();
}

class _SubredditHeaderState extends State<SubredditHeader> {
  @override
  Widget build(BuildContext context) {
    final String subStatus =
        dotenv.env['USER_IS_SUB'] == 'true' ? "Unsubscribe" : "Subscribe";
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            child: Center(
                child: Text("r/" + dotenv.env['SELECT_RESULT'].toString(),
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                child: Container(
                  child: Center(
                      child: Text(
                          dotenv.env['SUBREDDIT_SUBS'].toString() +
                              ' Subscribers',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                ),
              ),
              Expanded(
                child: TextButton(
                  child: Text(subStatus),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.teal,
                    onSurface: Colors.grey,
                  ),
                  onPressed: () async {
                    setState(() {});
                    String? token = dotenv.env['USER_TOKEN'];
                    final header = {'Authorization': 'bearer $token'};
                    final Uri url =
                        Uri.parse('https://oauth.reddit.com/api/subscribe');
                    if (dotenv.env['USER_IS_SUB'] == 'true') {
                      var body = {
                        "action": "unsub",
                        "sr_name": dotenv.env['SELECT_RESULT'].toString()
                      };
                      var response =
                          await http.post(url, headers: header, body: body);
                      print(response.statusCode);
                      dotenv.env['USER_IS_SUB'] = 'false';
                      print("\n\nYou Unsubbed\n\n");
                      subbSubreddits
                          .remove(dotenv.env['SELECT_RESULT'].toString());
                    } else {
                      var body = {
                        "action": "sub",
                        "skip_initial_defaults": "true",
                        "sr_name": dotenv.env['SELECT_RESULT'].toString()
                      };
                      var response =
                          await http.post(url, headers: header, body: body);
                      print(response.statusCode);
                      dotenv.env['USER_IS_SUB'] = 'true';
                      print("\n\nYou Subbed\n\n");
                      subbSubreddits
                          .add(dotenv.env['SELECT_RESULT'].toString());
                      subbSubreddits.toSet().toList();
                      //setState(() {});
                    }
                    subbSubreddits = [
                      ...{...subbSubreddits}
                    ]; // removes duplicates inside the subscribes subreddit list
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, bottom: 20, right: 20, left: 20),
            child: Center(
                child: dotenv.env['SUB_USES_BANNER'] == "false"
                    ? Container(
                        width: 256.0,
                        height: 256.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                dotenv.env['COMMUNITY_ICON'].toString()),
                          ),
                        ),
                      )
                    : Container(
                        width: 256.0,
                        height: 256.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: NetworkImage(
                                dotenv.env['COMMUNITY_ICON'].toString()),
                          ),
                        ),
                      )),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 0.0, bottom: 15.0, left: 5.0, right: 5.0),
            child: Text(dotenv.env['SUB_DESC'].toString(),
                style: TextStyle(fontSize: 12.0)),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(width: 2, color: Colors.grey.shade800)),
            ),
          ),
        ],
      ),
    );
  }
}
