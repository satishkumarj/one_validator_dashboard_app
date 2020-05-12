import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utilities/constants.dart';

class ListViewItem extends StatelessWidget {
  ListViewItem({@required this.title, @required this.text, this.moreDetails, this.openMoreDetails});
  final String title;
  final String text;
  final bool moreDetails;
  final Function openMoreDetails;

  @override
  Widget build(BuildContext context) {
    bool showArrow = false;
    if (moreDetails != null) {
      showArrow = moreDetails;
    }
    return Container(
      height: 65.0,
      child: ListTile(
        title: Text(
          '$title:',
          style: kLabelTextStyle,
          textAlign: TextAlign.left,
        ),
        subtitle: Text(
          text,
          style: kListDataTextStyle,
          textAlign: TextAlign.left,
        ),
        trailing: showArrow ? Icon(FontAwesomeIcons.chevronRight) : null,
        enabled: true,
        onTap: openMoreDetails,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: kListViewItemColor,
      ),
    );
  }
}
