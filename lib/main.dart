import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:redditech/pageManager.dart';

Future main() async {
  await dotenv.load(fileName: "assets/.env");
  WidgetsFlutterBinding.ensureInitialized();
  await InAppLocalhostServer().start();
  await Settings.init(cacheProvider: SharePreferenceCache());
  //runApp(new MyApp());
  runApp(PageManager());
}
