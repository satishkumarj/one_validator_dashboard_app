import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/resuable_card.dart';
import '../utilities/globals.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<Widget> settingItems = new List<Widget>();
  bool darkModeEnabled = false;
  bool isSwitched = false;

  void refreshData() {
    List<Widget> setItems = new List<Widget>();
    ListTile item = ListTile(
      leading: Text(
        'About',
        textAlign: TextAlign.center,
        style: GoogleFonts.nunito(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      trailing: Icon(
        FontAwesomeIcons.chevronRight,
      ),
    );
    setItems.add(item);
    SizedBox sb = SizedBox(height: 1);
    setItems.add(sb);

    setState(() {
      settingItems = setItems;
    });
  }

  void getDarkModeSetting() async {
    String darkModeEnabled = await Global.getUserPreferences('DARKMODE');
    if (darkModeEnabled == 'YES') {
      isSwitched = true;
    } else {
      isSwitched = false;
    }
  }

  @override
  void initState() {
    super.initState();
    getDarkModeSetting();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    Global.checkIfDarkModeEnabled(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            ReusableCard(
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: settingItems,
              ),
              colour: Global.isDarkModeEnabled ? Colors.black : Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
