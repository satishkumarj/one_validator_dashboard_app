import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard({@required this.colour, this.cardChild, this.onPress, this.blurRadius});
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
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 15, right: 15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: this.colour, boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: this.blurRadius != null ? this.blurRadius : 20.0, // has the effect of softening the shadow
            spreadRadius: 1.0, // has the effect of extending the shadow
            offset: Offset(
              5.0, // horizontal, move right 10
              5.0, // vertical, move down 10
            ),
          )
        ]),
      ),
    );
  }
}
