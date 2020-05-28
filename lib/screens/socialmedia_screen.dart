import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/resuable_card.dart';
import '../utilities/constants.dart';
import '../utilities/globals.dart';
import 'infor_screen.dart';

class SocialMediaScreen extends StatefulWidget {
  @override
  _SocialMediaScreenState createState() => _SocialMediaScreenState();
}

class _SocialMediaScreenState extends State<SocialMediaScreen> {
  List<dynamic> socialItems = new List<dynamic>();
  int itemsCount = 0;

  Future<void> _showMyDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Information  '),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  style: GoogleFonts.nunito(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: kHmyMainColor,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'OK',
                style: GoogleFonts.nunito(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: kHmyMainColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void gotoDiscussionScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InformationScreen(
          url: Global.forumUrl,
          title: 'Discuss',
        ),
      ),
    );
  }

  void gotoHarmonyScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InformationScreen(
          url: Global.harmonyOneUrl,
          title: 'Harmony.one',
        ),
      ),
    );
  }

  void openYoutube() async {
    if (Platform.isIOS) {
      if (await canLaunch(Global.harmonyYoutubeAppLink)) {
        await launch(Global.harmonyYoutubeAppLink, forceSafariVC: false);
      } else {
        if (await canLaunch(Global.harmonyYoutubeWebLink)) {
          print('Here');
          await launch(Global.harmonyYoutubeWebLink);
        } else {
          _showMyDialog('Something went wrong, please try again later.');
        }
      }
    } else {
      if (await canLaunch(Global.harmonyYoutubeWebLink)) {
        await launch(Global.harmonyYoutubeWebLink);
      } else {
        _showMyDialog('Something went wrong, please try again later.');
      }
    }
  }

  void openTelegram() async {
    if (await canLaunch(Global.harmonyTelegramLink)) {
      launch(Global.harmonyTelegramLink);
    } else {
      _showMyDialog('Something went wrong, please try again later.');
    }
  }

  void openPrarySoft() async {
    if (await canLaunch(Global.prarySoftLink)) {
      await launch(Global.prarySoftLink);
    } else {
      _showMyDialog('Something went wrong, please try again later.');
    }
  }

  void openMediumBlog() async {
    if (await canLaunch(Global.ogreAboardMediumLink)) {
      await launch(Global.ogreAboardMediumLink);
    } else {
      _showMyDialog('Something went wrong, please try again later.');
    }
  }

  void refreshData() {
    List<dynamic> setItems = new List<dynamic>();
    setItems.add(
      {
        'title': 'Discuss',
        'icon': FontAwesomeIcons.comment,
        'event': gotoDiscussionScreen,
      },
    );
    setItems.add(
      {
        'title': 'Harmony.one',
        'icon': FontAwesomeIcons.info,
        'event': gotoHarmonyScreen,
      },
    );
    setItems.add(
      {
        'title': 'Harmony Youtube Channel',
        'icon': FontAwesomeIcons.youtube,
        'event': openYoutube,
      },
    );
    setItems.add(
      {
        'title': 'Harmony Telegram',
        'icon': FontAwesomeIcons.telegram,
        'event': openTelegram,
      },
    );
    setItems.add(
      {
        'title': 'OgreAbroad\'s Blog',
        'icon': FontAwesomeIcons.blog,
        'event': openMediumBlog,
      },
    );
    setItems.add(
      {
        'title': 'PrArySoft.com',
        'icon': FontAwesomeIcons.windowRestore,
        'event': openPrarySoft,
      },
    );

    setState(() {
      socialItems = setItems;
      itemsCount = socialItems.length;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    Global.checkIfDarkModeEnabled(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Social'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: itemsCount,
              itemBuilder: (BuildContext context, int index) {
                var item = socialItems[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                  child: ReusableCard(
                    cardChild: ListTile(
                      trailing: Icon(
                        FontAwesomeIcons.chevronRight,
                        color: kHmyMainColor,
                        size: 20.0,
                      ),
                      leading: Icon(
                        item['icon'],
                        color: kHmyMainColor,
                        size: 20.0,
                      ),
                      title: Text(
                        item['title'],
                        style: GoogleFonts.nunito(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      onTap: item['event'],
                    ),
                    colour: Global.isDarkModeEnabled ? Colors.black : Colors.white,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
