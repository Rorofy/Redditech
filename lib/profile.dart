import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:redditech/accountPage.dart';
import 'package:redditech/globals.dart';

class IconWidget extends StatelessWidget {
  final IconData icon;
  final Color color;

  const IconWidget({Key? key, required this.icon, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(40),
              child: Container(
                width: 256.0,
                height: 256.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage("$userPhoto"),
                  ),
                ),
              ),
            ),
            Text(
              "$userName",
              style: TextStyle(fontSize: 25),
            ),
            Text(
              "$userProfileDesc",
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.justify,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                children: [
                  SettingsGroup(
                    title: '',
                    children: <Widget>[
                      AccountPage(),
                      //buildDarkMode(),
                      buildLogout(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLogout() {
    return SimpleSettingsTile(
      title: 'Logout',
      subtitle: '',
      leading: IconWidget(icon: Icons.logout, color: Colors.blueAccent),
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      },
    );
  }
}
