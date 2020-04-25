import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        trailing: showArrow ? Icon(Icons.keyboard_arrow_right) : null,
        enabled: true,
        onTap: openMoreDetails,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.tealAccent.withAlpha(160),
      ),
    );
  }
}
