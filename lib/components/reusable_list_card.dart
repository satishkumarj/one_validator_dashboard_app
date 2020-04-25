import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReusableListCard extends StatelessWidget {
  ReusableListCard(
      {@required this.colour, this.cardChild, this.onPress, this.blurRadius});
  final Color colour;
  final Widget cardChild;
  final Function onPress;
  final double blurRadius;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: cardChild,
        margin: EdgeInsets.only(top: 15.0, bottom: 5.0, left: 5, right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: this.colour,
        ),
      ),
    );
  }
}
