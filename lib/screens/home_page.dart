import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:validator/components/icon_content.dart';
import 'package:validator/components/resuable_card.dart';
import 'package:validator/models/validator_list_model.dart';
import 'package:validator/screens/analytics_screen.dart';
import 'package:validator/screens/balaces_screen.dart';
import 'package:validator/screens/delegator_screen.dart';
import 'package:validator/screens/enter_new_address.dart';
import 'package:validator/screens/favorite_validators.dart';
import 'package:validator/screens/infor_screen.dart';
import 'package:validator/screens/networks_screen.dart';
import 'package:validator/screens/notifications_screen.dart';
import 'package:validator/screens/validator_details.dart';
import 'package:validator/screens/validators.dart';
import 'package:validator/utilities/constants.dart';
import 'package:validator/utilities/globals.dart';
import 'package:validator/utilities/networking.dart';
import 'package:validator/utilities/notification_handler.dart';

import '../utilities/constants.dart';

enum ApiCallType { ApiCallTypeNetworkData, ApiCallTypeElectedValidators, ApiCallTypeAllValidators, ApiCallTypeGetBlockNumber }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  var blockData;
  double totalStake = 0;
  double medianStake = 0;
  int epochLastBlock = 0;
  int electedValidatorCount = 0;
  int allValidatorsCount = 0;
  String _myValONEAddress = '';
  String _myDelONEAddress = '';
  int blockNumber = 0;
  int minutesToNextEpoch = 0;
  Timer timer;

  static final List<Map> _menuItems = [
    {
      "text": "My Validator Details",
      "icon": Icon(
        FontAwesomeIcons.server,
        color: kHmyMainColor,
        size: 20,
      ),
    },
    {
      "text": "My Delegations",
      "icon": Icon(
        FontAwesomeIcons.tasks,
        color: kHmyMainColor,
        size: 20,
      ),
    },
    {
      "text": "Favorites",
      "icon": Icon(
        FontAwesomeIcons.heart,
        color: kHmyMainColor,
        size: 20,
      ),
    },
    {
      "text": "Analytics",
      "icon": Icon(
        FontAwesomeIcons.chartLine,
        color: kHmyMainColor,
        size: 20,
      ),
    },
    {
      "text": "Networks",
      "icon": Icon(
        FontAwesomeIcons.networkWired,
        color: kHmyMainColor,
        size: 20,
      ),
    },
    {
      "text": "Discuss",
      "icon": Icon(
        FontAwesomeIcons.comment,
        color: kHmyMainColor,
        size: 20,
      ),
    },
    {
      "text": "Documentation",
      "icon": Icon(
        FontAwesomeIcons.info,
        color: kHmyMainColor,
        size: 20,
      ),
    }
  ];

  void refreshData() {
    getData(ApiCallType.ApiCallTypeNetworkData);
    getData(ApiCallType.ApiCallTypeAllValidators);
    getData(ApiCallType.ApiCallTypeElectedValidators);
    getData(ApiCallType.ApiCallTypeGetBlockNumber);
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
    } else if (apiCallType == ApiCallType.ApiCallTypeGetBlockNumber) {
      apiMethod = kApiMethodBlockNumber;
    }
    var blockData = await networkHelper.getData(apiMethod, null);
    //print(blockData);
    if (blockData != null) {
      setState(() {
        if (apiCallType == ApiCallType.ApiCallTypeNetworkData) {
          epochLastBlock = blockData['result']['epoch-last-block'];
          totalStake = (blockData['result']['total-staking']) / Global.numberToDivide;
          double mStake = double.parse(blockData['result']['median-raw-stake']);
          medianStake = (mStake / Global.numberToDivide);
        } else if (apiCallType == ApiCallType.ApiCallTypeAllValidators) {
          allValidatorsCount = (blockData['result']).length;
        } else if (apiCallType == ApiCallType.ApiCallTypeElectedValidators) {
          electedValidatorCount = (blockData['result']).length;
        } else if (apiCallType == ApiCallType.ApiCallTypeGetBlockNumber) {
          blockNumber = blockData['result'];
        }
      });
      calculateNextEpochTime();
    }
    //print(blockData);
  }

  void calculateNextEpochTime() {
    int minToNextEp = ((epochLastBlock - blockNumber) ~/ Global.numberOfSecondsForEpoch).round();
//    if (minToNextEp > 60) {
//      minToNextEp = (minToNextEp ~/ 60).toInt();
//    }
    setState(() {
      minutesToNextEpoch = minToNextEp;
    });
  }

  void showAlert(String message) {
    Alert(context: context, title: "Validators", desc: message).show();
  }

  void gotoFavoriteValidator() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoriteValidators(),
      ),
    );
  }

  void gotoNotificationsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationsScreen(),
      ),
    );
  }

  void gotoMyDelegationDetails() {
    if (Global.myDelONEAddress == '') {
      showAlert('Please scan/enter your Delegator \'s ONE Address');
    } else {
      print(Global.myDelONEAddress);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DelegationDetailsScreen(
            oneAddress: Global.myDelONEAddress,
          ),
        ),
      );
    }
  }

  void gotoMyValidatorDetails() {
    if (Global.myValONEAddress == '') {
      showAlert('Please scan/enter your Validator \'s ONE Address');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ValidatorDetails(
            model: ValidatorListModel(name: 'Loading ...', address: Global.myValONEAddress),
          ),
        ),
      );
    }
  }

  void gotoAnalyticsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnalyticsScreen(),
      ),
    );
  }

  void gotoNetworksScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NetworksScreen(),
      ),
    );
  }

  void gotoMyBalanceDetails() {
    if (Global.myValONEAddress == '') {
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BalancesScreen(
            address: Global.myValONEAddress,
          ),
        ),
      );
    }
  }

  void gotoEnterNewAddressScreen(String type, String addressType) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnterNewAddressScreen(
          oneAddressType: addressType,
        ),
      ),
    );
    if (result != null) {
      if (result != '') {
        String oneAdd = result['address'];
        String addType = result['addressType'];
        if (addType == 'Validator') {
          setState(() {
            Global.myValONEAddress = oneAdd;
            _myValONEAddress = oneAdd;
          });
          Global.setUserPreferences(Global.oneValAddressKey, oneAdd);
        } else if (addType == 'Delegator') {
          setState(() {
            Global.myDelONEAddress = oneAdd;
            _myDelONEAddress = oneAdd;
          });
          Global.setUserPreferences(Global.oneDelAddressKey, oneAdd);
        }
        setState(() {
          OVDNotificationHandler.registerDevice(_myValONEAddress, addType);
        });
      }
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
    String add = await Global.getMyValONEAddress();
    Global.myValONEAddress = add;
    OVDNotificationHandler.registerDevice(Global.myValONEAddress, 'Validator');
    setState(() {
      _myValONEAddress = Global.myValONEAddress;
    });
  }

  void configureFirebaseListeners() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        //print("onMessage $message");
        String title = message['notification']['title'];
        String body = message['notification']['body'];
        //print('title $title, body $body');
        showNotification(title, body);
      },
      onLaunch: (Map<String, dynamic> message) async {
        //print("onLaunch $message");
        gotoMyValidatorDetails();
      },
      onResume: (Map<String, dynamic> message) async {
        //print("onResume $message");
        gotoMyValidatorDetails();
      },
    );
  }

  void showNotification(String title, String message) async {
    var android =
        new AndroidNotificationDetails('com.one.validator', 'ONE', 'notification_channel', importance: Importance.Max, priority: Priority.High);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      platform,
    );
  }

  void initialize() async {
    await Global.getInitializer();
  }

  @override
  void initState() {
    super.initState();
    initialize();
    configureFirebaseListeners();
    getMyOneAddress();

    refreshData();
    timer = Timer.periodic(Duration(seconds: Global.dataRefreshInSeconds), (Timer t) => refreshData());
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      endDrawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/validator_header.png",
                      height: 80.0,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'One Validator Dashboard',
                          style: GoogleFonts.nunito(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: kHmyTitleTextColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                  ],
                ),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
              ),
              ListView.separated(
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
                        style: GoogleFonts.nunito(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: kHmyTitleTextColor,
                        ),
                      ),
                      trailing: index == 0 || index == 1
                          ? GestureDetector(
                              child: Icon(
                                FontAwesomeIcons.qrcode,
                                size: 20.0,
                                color: Colors.black,
                              ),
                              onTap: () {
                                gotoEnterNewAddressScreen('OWN', index == 0 ? 'Validator' : 'Delegator');
                              },
                            )
                          : null,
                      subtitle: index == 0 || index == 1
                          ? Text(
                              index == 0
                                  ? Global.myValONEAddress == '' ? 'Please scan/enter your Validator address' : Global.myValONEAddress
                                  : Global.myDelONEAddress == '' ? 'Please scan/enter your Delegator address' : Global.myDelONEAddress,
                              style: GoogleFonts.nunito(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: kHmyNormalTextColor,
                              ),
                            )
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        switch (index) {
                          case 0:
                            gotoMyValidatorDetails();
                            break;
                          case 1:
                            gotoMyDelegationDetails();
                            break;
                          case 2:
                            gotoFavoriteValidator();
                            break;
                          case 3:
                            gotoAnalyticsScreen();
                            break;
                          case 4:
                            gotoNetworksScreen();
                            break;
                          case 5:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InformationScreen(
                                  url: Global.forumUrl,
                                  title: 'Discuss',
                                ),
                              ),
                            );
                            break;
                          case 6:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InformationScreen(
                                  url: Global.docsUrl,
                                  title: 'Documentation',
                                ),
                              ),
                            );
                            break;
                          default:
                            break;
                        }
                      },
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.black,
                    height: 15.0,
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
                      style: GoogleFonts.nunito(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 45.0,
                        color: kHmyMainColor,
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
                      fillColor: kHmyMainColor,
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
                    style: GoogleFonts.nunito(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: kHmyMainColor,
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
                      color: kHmyMainColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Expanded(
          flex: 9,
          child: ListView(
            padding: const EdgeInsets.all(5),
            shrinkWrap: true,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: double.infinity, minHeight: 100.0),
                      child: ReusableCard(
                        onPress: () {},
                        colour: Colors.white,
                        cardChild: ContentCard(
                          data: "${kUSNumberFormat.format(medianStake)}",
                          title: "Median Stake",
                          mediumAssetIcon: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 15.0,
                            backgroundImage: AssetImage('assets/onelogo.png'),
                          ),
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: double.infinity, minHeight: 100.0),
                      child: ReusableCard(
                        onPress: () {},
                        colour: Colors.white,
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
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: double.infinity, minHeight: 100.0),
                      child: ReusableCard(
                        onPress: () {},
                        colour: Colors.white,
                        cardChild: ContentCard(title: "Current Block Height", data: "#$blockNumber"),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: double.infinity, minHeight: 100.0),
                      child: ReusableCard(
                        onPress: () {},
                        colour: Colors.white,
                        cardChild: ContentCard(
                          title: "Next Epoch",
                          data: minutesToNextEpoch >= 0 ? "$minutesToNextEpoch" : "0",
                          subData: 'mins',
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: double.infinity, minHeight: 100.0),
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 10.0,
                          left: 5.0,
                          right: 5.0,
                          bottom: 5.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: double.infinity, minHeight: 60.0),
                              child: Text(
                                'Validators',
                                style: GoogleFonts.nunito(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35.0,
                                  color: kHmyMainColor,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ConstrainedBox(
                                  constraints:
                                      BoxConstraints(maxHeight: double.infinity, minHeight: 180.0, maxWidth: double.infinity, minWidth: 170.0),
                                  child: ReusableCard(
                                    colour: Colors.white,
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
                                ConstrainedBox(
                                  constraints:
                                      BoxConstraints(maxHeight: double.infinity, minHeight: 180.0, maxWidth: double.infinity, minWidth: 170.0),
                                  child: ReusableCard(
                                    colour: Colors.white,
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
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
