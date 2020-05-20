import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validator/utilities/constants.dart';

class ListContentCard extends StatelessWidget {
  ListContentCard({
    this.title,
    this.data,
    @required this.elected,
  });

  final String title;
  final String data;
  final bool elected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              this.data,
              style: GoogleFonts.nunito(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: kHmyTitleTextColor,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              this.title,
              style: GoogleFonts.nunito(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: kHmyNormalTextColor,
              ),
            ),
          ],
        )
      ],
    );
  }
}
