import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validator/components/icon_content.dart';
import 'package:validator/components/resuable_card.dart';
import 'package:validator/screens/validators.dart';
import 'package:validator/utilities/constants.dart';
import 'package:validator/utilities/networking.dart';

enum ApiCallType {
  ApiCallTypeNetworkData,
  ApiCallTypeElectedValidators,
  ApiCallTypeAllValidators,
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var blockData;
  double totalStake = 0;
  double medianStake = 0;
  int epochLastBlock = 0;
  int electedValidatorCount = 0;
  int allValidatorsCount = 0;

  void refreshData() {
    getData(ApiCallType.ApiCallTypeNetworkData);
    getData(ApiCallType.ApiCallTypeAllValidators);
    getData(ApiCallType.ApiCallTypeElectedValidators);
  }

  void getData(ApiCallType apiCallType) async {
    NetworkHelper networkHelper = NetworkHelper();
    String apiMethod = '';
    if (apiCallType == ApiCallType.ApiCallTypeNetworkData) {
      apiMethod = kApiMethodGetStakingNetworkInfo;
    } else if (apiCallType == ApiCallType.ApiCallTypeAllValidators) {
      apiMethod = kApiMethodGetAllValidatorAddresses;
    } else if (apiCallType == ApiCallType.ApiCallTypeElectedValidators) {
      apiMethod = kApiMethodGetElectedValidatorAddresses;
    }
    var blockData = await networkHelper.getData(apiMethod, null);
    //print(blockData);
    setState(() {
      if (blockData != null) {
        if (apiCallType == ApiCallType.ApiCallTypeNetworkData) {
          epochLastBlock = blockData['result']['epoch-last-block'];
          totalStake = (blockData['result']['total-staking']) / kNumberToDivide;
          double mStake = double.parse(blockData['result']['median-raw-stake']);
          medianStake = (mStake / kNumberToDivide);
        } else if (apiCallType == ApiCallType.ApiCallTypeAllValidators) {
          allValidatorsCount = (blockData['result']).length;
        } else if (apiCallType == ApiCallType.ApiCallTypeElectedValidators) {
          electedValidatorCount = (blockData['result']).length;
        }
      }
    });
    //print(blockData);
  }

  void pushToValidator(String validatorType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ValidatorsScreen(
          validatorType: validatorType,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: 45.0,
                left: 15.0,
                right: 15.0,
                bottom: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Harmony',
                    style: TextStyle(
                      color: kMainColor,
                      fontSize: 50.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Open Staking',
                        style: TextStyle(
                          color: kMainColor,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          refreshData();
                        },
                        child: Icon(
                          FontAwesomeIcons.sync,
                          size: 18,
                          color: kMainColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: ReusableCard(
                      onPress: () {},
                      colour: kMainColor,
                      cardChild: ContentCard(
                        data: "${kUSNumberFormat.format(medianStake)}",
                        title: "Median Raw Stake",
                        mediumAssetIcon: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15.0,
                          backgroundImage: AssetImage('assets/onelogo.png'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      onPress: () {},
                      colour: kMainColor,
                      cardChild: ContentCard(
                        title: "Total Stake",
                        data: "${kUSNumberFormat.format(totalStake)}",
                        mediumAssetIcon: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15.0,
                          backgroundImage: AssetImage('assets/onelogo.png'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      onPress: () {},
                      colour: kMainColor,
                      cardChild: ContentCard(
                          title: "Current Block Height",
                          data: "#$epochLastBlock"),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
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
                        color: kMainColor,
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
                                data: "$electedValidatorCount",
                                smallIcon: FontAwesomeIcons.userCheck,
                              ),
                              onPress: () {
                                pushToValidator('Elected');
                              },
                            ),
                          ),
                          Expanded(
                            child: ReusableCard(
                              colour: kBlueGreyCardColor,
                              cardChild: ContentCard(
                                title: "All",
                                data: "$allValidatorsCount",
                                smallIcon: FontAwesomeIcons.users,
                              ),
                              onPress: () {
                                pushToValidator('All');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}
