import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validator/components/icon_content.dart';
import 'package:validator/components/resuable_card.dart';
import 'package:validator/utilities/constants.dart';

import '../utilities/globals.dart';

class BalancesScreen extends StatefulWidget {
  BalancesScreen({this.address});
  final String address;

  @override
  _BalancesScreenState createState() => _BalancesScreenState();
}

class _BalancesScreenState extends State<BalancesScreen> {
  bool dataLoading = false;
  double firstBalance = 0;
  double secondBalance = 0;
  double thirdBalance = 0;
  double fourthBalance = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Global.checkIfDarkModeEnabled(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Balaces'),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: dataLoading
          ? SpinKitDoubleBounce(
              color: Colors.grey,
              size: 50.0,
            )
          : Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.only(
                  top: 20.0,
                  left: 15.0,
                  right: 15.0,
                  bottom: 30.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Validators',
                      style: TextStyle(
                        color: kHmyMainColor,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ReusableCard(
                              colour: kListBackgroundGreen,
                              cardChild: ContentCard(
                                title: "Elected",
                                data: "0",
                                smallIcon: FontAwesomeIcons.userCheck,
                              ),
                              onPress: () {},
                            ),
                          ),
                          Expanded(
                            child: ReusableCard(
                              colour: kHmyGreyCardColor,
                              cardChild: ContentCard(
                                title: "All",
                                data: "0",
                                smallIcon: FontAwesomeIcons.users,
                              ),
                              onPress: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
