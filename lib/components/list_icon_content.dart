import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validator/utilities/constants.dart';

import '../utilities/constants.dart';

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
              style: kListDataTextStyle,
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
              style: this.elected ? kListElectedLabelTextStyle : kListLabelTextStyle,
            ),
          ],
        )
      ],
    );
  }
}
