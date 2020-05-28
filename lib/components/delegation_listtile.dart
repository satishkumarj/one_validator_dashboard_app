import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validator/components/list_icon_content.dart';
import 'package:validator/components/resuable_card.dart';
import 'package:validator/components/reusable_list_card.dart';
import 'package:validator/models/delegation.dart';
import 'package:validator/utilities/constants.dart';

import '../utilities/globals.dart';

class DelegationListTile extends StatelessWidget {
  DelegationListTile({@required this.model, @required this.context});
  final Delegation model;

  final BuildContext context;

  void openValidatorDetailsScreen() {}

  @override
  Widget build(BuildContext context) {
    //String addressWrapped = model.address.substring(0, 10) + '...' + model.address.substring(model.address.length - 10, model.address.length);
    return GestureDetector(
      onTap: () {
        openValidatorDetailsScreen();
      },
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: ReusableCard(
          colour: Global.isDarkModeEnabled ? Colors.black : Colors.white,
          cardChild: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Icon(
                      FontAwesomeIcons.tasks,
                      size: 15.0,
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Text(
                      'Validator:',
                      style: GoogleFonts.nunito(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 40.0,
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: SelectableText(
                      model.validatorName == null ? '' : model.validatorName,
                      style: GoogleFonts.nunito(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: kHmyNormalTextColor,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ReusableListCard(
                      cardChild: ListContentCard(
                        title: "Delegated",
                        data: model.amount == null ? '0' : kUSNumberFormat.format(model.amount),
                        elected: true,
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
                        title: "Reward",
                        data: model.reward == null ? '0' : kUSNumberFormat.format(model.reward),
                        elected: true,
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
        ),
      ),
    );
  }
}
