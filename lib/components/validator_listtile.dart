import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validator/components/list_icon_content.dart';
import 'package:validator/components/reusable_list_card.dart';
import 'package:validator/models/validator_list_model.dart';
import 'package:validator/screens/validator_details.dart';
import 'package:validator/utilities/constants.dart';

class ValidatorListTile extends StatelessWidget {
  ValidatorListTile({@required this.model, @required this.context});
  final ValidatorListModel model;

  final BuildContext context;

  void openValidatorDetailsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ValidatorDetails(
          model: this.model,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Color> _colors = [
      Color(0XFF00BCD4),
      Color(0XFF00BCD4),
      Color(0XFF80DEEA),
      Color(0XFF00BCD4),
      Color(0XFF00BCD4),
      Color(0XFF80DEEA),
    ];
    List<double> _stops = [0.1, 0.2, 0.4, 0.6, 0.8, 1.0];

    //String addressWrapped = model.address.substring(0, 10) + '...' + model.address.substring(model.address.length - 10, model.address.length);
    return GestureDetector(
      onTap: () {
        openValidatorDetailsScreen();
      },
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Icon(
                    model.elected ? FontAwesomeIcons.userCheck : FontAwesomeIcons.userAlt,
                    size: 15.0,
                    color: Colors.orange,
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Text(
                    model.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              model.address == null ? '' : model.address,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ReusableListCard(
                    cardChild: ListContentCard(
                      title: "Total Staked",
                      data: model.totalStaked == null ? '0' : kUSNumberFormat.format(model.totalStaked),
                      elected: model.elected,
                    ),
                    onPress: () {
                      openValidatorDetailsScreen();
                    },
                    blurRadius: 20,
                  ),
                ),
                Expanded(
                  child: ReusableListCard(
                    cardChild: ListContentCard(
                      title: "Lifetime Earned",
                      data: model.earnings == null ? '0' : kUSNumberFormat.format(model.earnings),
                      elected: model.elected,
                    ),
                    onPress: () {
                      openValidatorDetailsScreen();
                    },
                    blurRadius: 20,
                  ),
                ),
              ],
            )
          ],
        ),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0, // has the effect of softening the shadow
            spreadRadius: 1.0, // has the effect of extending the shadow
            offset: Offset(
              1.0, // horizontal, move right 10
              3.0, // vertical, move down 10
            ),
          )
        ], borderRadius: BorderRadius.circular(25.0), color: model.elected ? kGreenCardColor : kBlueGreyCardColor),
      ),
    );
  }
}
