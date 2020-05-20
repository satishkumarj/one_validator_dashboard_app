import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validator/components/list_icon_content.dart';
import 'package:validator/components/resuable_card.dart';
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
        child: ReusableCard(
          colour: Colors.white,
          cardChild: Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Icon(
                      model.elected ? FontAwesomeIcons.userCheck : FontAwesomeIcons.userAlt,
                      size: 15.0,
                      color: model.elected ? kHmyGreenCardColor : kHmyGreyCardColor,
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Text(
                      model.name,
                      style: GoogleFonts.nunito(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: kHmyTitleTextColor,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  )
                ],
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
                    ),
                  ),
                  Expanded(
                    child: ReusableListCard(
                      cardChild: ListContentCard(
                        title: "Expected Return",
                        data: model.expectedReturn == null ? '0%' : '${kUSPercentageNumberFormat.format(model.expectedReturn)}%',
                        elected: model.elected,
                      ),
                      onPress: () {
                        openValidatorDetailsScreen();
                      },
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
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
