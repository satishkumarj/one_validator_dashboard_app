import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validator/screens/home_page.dart';
import 'package:validator/utilities/constants.dart';

import 'utilities/constants.dart';

void main() => runApp(OneValidatorDashboardApp());

class OneValidatorDashboardApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harmony (ONE) Validator Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        primaryColor: kHmyMainColor,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        primaryIconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        primaryTextTheme: TextTheme(
          headline6: GoogleFonts.nunitoSans(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            color: kHmyTitleTextColor,
          ),
          subtitle1: GoogleFonts.nunito(
            fontStyle: FontStyle.normal,
            color: kHmyTitleTextColor,
          ),
          bodyText1: GoogleFonts.nunito(
            fontStyle: FontStyle.normal,
            color: kHmyNormalTextColor,
          ),
          bodyText2: GoogleFonts.nunito(
            fontStyle: FontStyle.normal,
            color: kHmyNormalTextColor,
          ),
          caption: GoogleFonts.nunito(
            fontStyle: FontStyle.normal,
            color: kHmyNormalTextColor,
          ),
          button: GoogleFonts.nunito(
            fontStyle: FontStyle.normal,
            color: kHmyNormalTextColor,
          ),
          overline: GoogleFonts.nunito(
            fontStyle: FontStyle.normal,
            color: kHmyNormalTextColor,
          ),
        ),
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.black,
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        primaryIconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        primaryTextTheme: TextTheme(
          headline6: GoogleFonts.nunitoSans(
            fontStyle: FontStyle.normal,
            color: Colors.white,
          ),
          subtitle1: GoogleFonts.nunito(
            fontStyle: FontStyle.normal,
            color: Colors.white,
          ),
          bodyText1: GoogleFonts.nunito(
            fontStyle: FontStyle.normal,
            color: Colors.white,
          ),
          bodyText2: GoogleFonts.nunito(
            fontStyle: FontStyle.normal,
            color: Colors.white,
          ),
          overline: GoogleFonts.nunito(
            fontStyle: FontStyle.normal,
            color: Colors.white,
          ),
          button: GoogleFonts.nunito(
            fontStyle: FontStyle.normal,
            color: Colors.white,
          ),
          caption: GoogleFonts.nunito(
            fontStyle: FontStyle.normal,
            color: Colors.white,
          ),
        ),
      ),
      home: MyHomePage(title: 'Validators'),
    );
  }
}
