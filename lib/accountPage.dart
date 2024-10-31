import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:redditech/profile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redditech/popup.dart';
import 'package:redditech/globals.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);
  static const keyLanguage = 'key-language';
  static const keyIncomingMessage = 'key-incoming-message';
  static const keyClicktracking = 'key-clicktracking';
  static const keyFollowers = 'key-followers';
  static const keyVotes = 'key-votes';
  static const keyBeta = 'key-beta';

  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
      title: 'Account Settings',
      subtitle: '',
      leading: IconWidget(icon: Icons.person, color: Colors.green),
      child: SettingsScreen(
        title: 'Account Settings',
        children: <Widget>[
          buildLanguage(),
          buildIncomingMessage(),
          buildClicktracking(),
          buildFollowers(),
          buildVotes(),
          buildBeta(),
          buildUpdate(context),
        ],
      ),
    );
  }

  Widget buildIncomingMessage() {
    return DropDownSettingsTile(
        title: 'Accept incoming private messages',
        settingKey: keyIncomingMessage,
        selected: 1,
        values: <int, String>{
          1: 'Everyone',
          2: 'Whitelisted only',
        },
        onChange: (value) {
          switch (value) {
            case 1:
              incomingMessage = 'everyone';
              break;
            case 2:
              incomingMessage = 'whitelisted';
              break;
            default:
              incomingMessage = 'everyone';
              break;
          }
        });
  }

  Widget buildClicktracking() {
    return DropDownSettingsTile(
        title: 'Allow clicktracking',
        settingKey: keyClicktracking,
        selected: 1,
        values: <int, String>{
          1: 'True',
          2: 'False',
        },
        onChange: (value) {
          switch (value) {
            case 1:
              clicktracking = 'true';
              break;
            case 2:
              clicktracking = 'false';
              break;
            default:
              clicktracking = 'true';
              break;
          }
        });
  }

  Widget buildFollowers() {
    return DropDownSettingsTile(
        title: 'Enable Followers',
        settingKey: keyFollowers,
        selected: 1,
        values: <int, String>{
          1: 'True',
          2: 'False',
        },
        onChange: (value) {
          switch (value) {
            case 1:
              followers = 'true';
              break;
            case 2:
              followers = 'false';
              break;
            default:
              followers = 'true';
              break;
          }
        });
  }

  Widget buildLanguage() {
    return DropDownSettingsTile(
        title: 'Region Preferences',
        settingKey: keyLanguage,
        selected: 1,
        values: <int, String>{
          1: 'Global',
          2: 'United States',
          3: 'France',
          4: 'Germany',
          5: 'Australia',
        },
        onChange: (value) {
          switch (value) {
            case 1:
              region = 'GLOBAL';
              break;
            case 2:
              region = 'US';
              break;
            case 3:
              region = 'FR';
              break;
            case 4:
              region = 'DE';
              break;
            case 5:
              region = 'AU';
              break;
            default:
              region = 'GLOBAL';
              break;
          }
        });
  }

  Widget buildVotes() {
    return DropDownSettingsTile(
        title: 'Make my votes public',
        settingKey: keyVotes,
        selected: 1,
        values: <int, String>{
          1: 'True',
          2: 'False',
        },
        onChange: (value) {
          switch (value) {
            case 1:
              votes = 'true';
              break;
            case 2:
              votes = 'false';
              break;
            default:
              votes = 'true';
              break;
          }
        });
  }

  Widget buildBeta() {
    return DropDownSettingsTile(
        title: 'Reddit Beta',
        settingKey: keyBeta,
        selected: 1,
        values: <int, String>{
          1: 'True',
          2: 'False',
        },
        onChange: (value) {
          switch (value) {
            case 1:
              beta = 'true';
              break;
            case 2:
              beta = 'false';
              break;
            default:
              beta = 'true';
              break;
          }
        });
  }

  Widget buildUpdate(context) {
    return SimpleSettingsTile(
      title: 'Update User Settings',
      subtitle: '',
      onTap: () async {
        incomingMessage = incomingMessage == '' ? 'unchanged' : incomingMessage;
        clicktracking = clicktracking == '' ? 'unchanged' : clicktracking;
        followers = followers == '' ? 'unchanged' : followers;
        region = region == '' ? 'unchanged' : region;
        votes = votes == '' ? 'unchanged' : votes;
        beta = beta == '' ? 'unchanged' : beta;
        var data = {
          "accept_pms": incomingMessage,
          "allow_clicktracking": clicktracking,
          "beta": beta,
          "g": region,
          "public_votes": votes,
          "enable_followers": followers,
        };
        var dataToRemove = {};
        data.entries.forEach((element) {
          if (element.value.contains('unchanged')) {
            dataToRemove.putIfAbsent(
                '${element.key}', () => '${element.value}');
          }
        });
        data.removeWhere((key, value) => dataToRemove.containsKey(key));
        print("This is data: $data");
        if (data.isEmpty) {
          print("Notification Empty");
          // pop notification "No settings modified"
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Popup("No settings modified")));
        } else {
          print("Modifying user data");
          String? token = dotenv.env['USER_TOKEN'];
          final header = {
            'Authorization': 'bearer $token',
          };
          Uri basicUrl = Uri.https("oauth.reddit.com", "/api/v1/me/prefs");
          final http.Response response = await http.patch(basicUrl,
              headers: header, body: convert.jsonEncode(data));
          print(response.statusCode);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Popup("User settings updated")));
        }
      },
    );
  }
}
