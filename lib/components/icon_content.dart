import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validator/utilities/constants.dart';

class ContentCard extends StatelessWidget {
  ContentCard({this.title, this.data, this.smallIcon, this.smallIconColor, this.mediumAssetIcon, this.subData});

  final String title;
  final String data;
  final String subData;
  final IconData smallIcon;
  final Color smallIconColor;
  final CircleAvatar mediumAssetIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            mediumAssetIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: mediumAssetIcon,
                  )
                : SizedBox(),
            Text(
              this.data,
              style: kDataTextStyle,
            ),
            subData != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Text(
                      subData,
                      style: kSubLabelTextStyle,
                    ),
                  )
                : SizedBox(),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              smallIcon,
              size: 14,
              color: smallIconColor != null ? smallIconColor : Colors.orange,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              this.title,
              style: kLabelTextStyle,
            ),
          ],
        )
      ],
    );
  }
}
