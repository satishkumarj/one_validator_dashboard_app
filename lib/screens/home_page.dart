import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:validator/components/icon_content.dart';
import 'package:validator/components/resuable_card.dart';
import 'package:validator/models/validator_list_model.dart';
import 'package:validator/screens/balaces_screen.dart';
import 'package:validator/screens/infor_screen.dart';
import 'package:validator/screens/validator_details.dart';
import 'package:validator/screens/validators.dart';
import 'package:validator/utilities/constants.dart';
import 'package:validator/utilities/globals.dart';
import 'package:validator/utilities/networking.dart';

import '../utilities/constants.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var blockData;
  double totalStake = 0;
  double medianStake = 0;
  int epochLastBlock = 0;
  int electedValidatorCount = 0;
  int allValidatorsCount = 0;
  String _myONEAddress = '';

  static final List<Map> _menuItems = [
    {
      "text": "My Node Details",
      "icon": Icon(
        FontAwesomeIcons.server,
        color: Colors.white,
      ),
    },
    {
      "text": "Documentation",
      "icon": Icon(
        FontAwesomeIcons.info,
        color: Colors.white,
      ),
    }
  ];

  /*
  ,
    {
      "text": "Check Balance",
      "icon": Icon(
        FontAwesomeIcons.moneyBill,
        color: Colors.white,
      ),
    },
   */
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

  void showAlert(String message) {
    Alert(context: context, title: "Validators", desc: message).show();
  }

  void scanQRCode() async {
    var result = await BarcodeScanner.scan();
    Global.myONEAddress = result.rawContent;
    Global.setUserPreferences(Global.oneAddressKey, result.rawContent);
    setState(() {
      _myONEAddress = result.rawContent;
    });
  }

  void gotoMyValidatorDetails() {
    if (Global.myONEAddress == '') {
      showAlert('Please scan your ONE Address');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ValidatorDetails(
            model: ValidatorListModel(name: 'Loading ...', address: Global.myONEAddress),
          ),
        ),
      );
    }
  }

  void gotoMyBalanceDetails() {
    if (Global.myONEAddress == '') {
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BalancesScreen(
            address: Global.myONEAddress,
          ),
        ),
      );
    }
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

  void getMyOneAddress() async {
    String add = await Global.getMyONEAddress();
    Global.myONEAddress = add;
    setState(() {
      _myONEAddress = add;
    });
  }

  @override
  void initState() {
    super.initState();
    getMyOneAddress();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      endDrawer: Drawer(
        child: Container(
          color: kMainColor,
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/validator_header.png",
                      height: 100.0,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _myONEAddress == ''
                              ? 'Please scan your address'
                              : _myONEAddress.substring(0, 10) + '...' + _myONEAddress.substring((_myONEAddress.length - 11)),
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          child: Icon(
                            FontAwesomeIcons.qrcode,
                            size: 22.0,
                            color: Colors.black,
                          ),
                          onTap: () {
                            scanQRCode();
                          },
                        )
                      ],
                    )
                  ],
                ),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _menuItems.length,
                itemBuilder: (BuildContext context, int index) {
                  Map item = _menuItems[index];
                  return Container(
                    child: ListTile(
                      leading: item['icon'],
                      title: Text(
                        item['text'],
                        style: TextStyle(
                          color: kBlueColor,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        switch (index) {
                          case 0:
                            gotoMyValidatorDetails();
                            break;
                          case 1:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InformationScreen(),
                              ),
                            );
                            break;
                          case 2:
                            break;
                          default:
                            break;
                        }
                      },
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.tealAccent.withAlpha(160),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Text(
                      'Harmony',
                      style: TextStyle(
                        color: kMainColor,
                        fontSize: 50.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: RawMaterialButton(
                      onPressed: () {
                        _scaffoldKey.currentState.openEndDrawer();
                      },
                      elevation: 3.0,
                      fillColor: kMainColor,
                      child: Icon(
                        Icons.list,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(10.0),
                      shape: CircleBorder(),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      Icons.refresh,
                      size: 20,
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
                  cardChild: ContentCard(title: "Current Block Height", data: "#$epochLastBlock"),
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
