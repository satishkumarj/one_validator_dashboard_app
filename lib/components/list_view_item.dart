import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utilities/constants.dart';
import '../utilities/globals.dart';

class ListViewItem extends StatelessWidget {
  ListViewItem({@required this.title, @required this.text, this.moreDetails, this.openMoreDetails, this.selectable, this.height});
  final String title;
  final String text;
  final bool moreDetails;
  final Function openMoreDetails;
  final bool selectable;
  final double height;

  @override
  Widget build(BuildContext context) {
    bool showArrow = false;
    if (moreDetails != null) {
      showArrow = moreDetails;
    }
    return Container(
      height: height != null ? height : 80.0,
      child: ListTile(
        title: SelectableText(
          '$title',
          style: GoogleFonts.nunito(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          textAlign: TextAlign.left,
        ),
        subtitle: selectable == true
            ? SelectableText(
                text,
                style: GoogleFonts.nunito(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: kHmyNormalTextColor,
                ),
                textAlign: TextAlign.left,
              )
            : Text(
                text,
                style: GoogleFonts.nunito(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: kHmyNormalTextColor,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 6,
              ),
        trailing: showArrow ? Icon(FontAwesomeIcons.chevronRight) : null,
        enabled: true,
        onTap: openMoreDetails,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Global.isDarkModeEnabled ? Colors.black : Colors.white,
      ),
    );
  }
}
