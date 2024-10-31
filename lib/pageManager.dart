import 'package:flutter/material.dart';
import 'package:redditech/profile.dart';
import 'package:redditech/subredditPage.dart';
import 'package:redditech/welcome.dart';
import 'package:redditech/redditLoginWebView.dart';
import 'package:redditech/generalFeedPage.dart';

class PageManager extends StatefulWidget {
  const PageManager({Key? key}) : super(key: key);

  @override
  _PageManagerState createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Redditech',
      routes: {
        '/subreddit': (context) => SubredditPage(),
        '/general': (context) => GeneralFeedPage(),
        '/profile': (context) => ProfilePage(),
        '/login': (context) => RedditechLogin(),
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto'),
          headline6: TextStyle(fontSize: 26.0, fontFamily: 'Roboto'),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Roboto'),
        ),
      ),
      home: WelcomePage(),
    );
  }
}
