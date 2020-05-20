import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:validator/components/resuable_card.dart';
import 'package:validator/models/validator_list_model.dart';
import 'package:validator/screens/delegator_screen.dart';
import 'package:validator/screens/enter_new_address.dart';
import 'package:validator/screens/validator_details.dart';
import 'package:validator/utilities/constants.dart';
import 'package:validator/utilities/globals.dart';
import 'package:validator/utilities/networking.dart';

class FavoriteValidators extends StatefulWidget {
  @override
  _FavoriteValidatorsState createState() => _FavoriteValidatorsState();
}

class _FavoriteValidatorsState extends State<FavoriteValidators> {
  int favValCount = 0;
  List<String> favValAddsKeys = new List<String>();
  Map<String, String> favValAdds = new Map<String, String>();
  int favDelCount = 0;
  List<String> favDelAddsKeys = new List<String>();
  int _currentSelection = 0;
  String oneAddressType = 'Validator';
  Map<int, Widget> _children;

  void scanQRCode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnterNewAddressScreen(
          oneAddressType: oneAddressType,
        ),
      ),
    );
    if (result != null) {
      if (result != '') {
        String favAddress = result['address'];
        String addressType = result['addressType'];
        if (addressType == 'Validator') {
          NetworkHelper networkHelper = NetworkHelper();
          var blockData = await networkHelper.getData(kApiMethodGetValidatorInformation, favAddress);
          if (blockData != null) {
            if (blockData["error"] != null) {
              String error = blockData['error']['message'];
              if (error.contains('not found address in current state')) {
                error = 'No validator found with $favAddress address in current state';
              }
              Alert(context: context, title: "Validators", desc: error).show();
            } else {
              String validatorName = blockData['result']['validator']['name'];
              Global.setUserPreferences(favAddress, validatorName);
              setState(() {
                if (favValAdds[favAddress] == null) {
                  favValAdds[favAddress] = validatorName;
                  favValAddsKeys.add(favAddress);
                  favValCount = favValAddsKeys.length;
                }
              });
              Global.setUserFavList(Global.favoriteValListKey, favValAddsKeys);
            }
          }
        } else if (addressType == 'Delegator') {
          Global.setUserPreferences(favAddress, favAddress);
          if (favDelAddsKeys.indexOf(favAddress) < 0) {
            setState(() {
              favDelAddsKeys.add(favAddress);
              favDelCount = favDelAddsKeys.length;
            });
          }
          Global.setUserFavList(Global.favoriteDelListKey, favDelAddsKeys);
        }
      }
    }
  }

  Future<void> getFavValAddressList() async {
    favValAddsKeys = await Global.getUserFavList(Global.favoriteValListKey);
    Map<String, String> favAddKeysAndNames = new Map<String, String>();
    for (int i = 0; i < favValAddsKeys.length; i++) {
      String add = favValAddsKeys[i];
      favAddKeysAndNames[add] = await Global.getUserPreferences(add);
    }
    setState(() {
      favValAdds = favAddKeysAndNames;
      favValCount = favValAddsKeys.length;
    });
  }

  Future<void> getFavDelAddressList() async {
    favDelAddsKeys = await Global.getUserFavList(Global.favoriteDelListKey);
    setState(() {
      favDelCount = favDelAddsKeys.length;
    });
  }

  void gotoValidatorDetails(String address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ValidatorDetails(
          model: ValidatorListModel(name: favValAdds[address], address: address),
        ),
      ),
    );
  }

  void gotoDelegationDetails(String address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DelegationDetailsScreen(
          oneAddress: address,
        ),
      ),
    );
  }

  void refreshData() async {
    await getFavValAddressList();
    await getFavDelAddressList();
  }

  void refreshSegItems() {
    setState(() {
      _children = {
        0: Text('Validators'),
        1: Text('Delegators'),
      };
    });
  }

  @override
  void initState() {
    super.initState();
    refreshSegItems();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                scanQRCode();
              },
              child: Icon(
                Icons.add,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: MaterialSegmentedControl(
                children: _children,
                selectionIndex: _currentSelection,
                borderColor: Colors.grey,
                selectedColor: kHmyMainColor,
                unselectedColor: Colors.white,
                borderRadius: 32.0,
                onSegmentChosen: (index) {
                  setState(() {
                    _currentSelection = index;
                    if (_currentSelection == 0) {
                      oneAddressType = 'Validator';
                    } else {
                      oneAddressType = 'Delegator';
                    }
                  });
                },
              ),
            ),
            _currentSelection == 0
                ? Expanded(
                    child: favValCount == 0
                        ? Container(
                            padding: EdgeInsets.only(top: 5.0, right: 10.0, left: 10.0),
                            child: Center(
                              child: Text(
                                'No favorites, please add using +',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: kHmyNormalTextColor,
                                ),
                              ),
                            ),
                          )
                        : ListView(
                            children: <Widget>[
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: favValCount,
                                itemBuilder: (BuildContext context, int index) {
                                  String item = favValAddsKeys[index];
                                  return Dismissible(
                                    key: UniqueKey(),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (DismissDirection direction) {
                                      setState(() {
                                        favValAddsKeys.removeAt(index);
                                        favValCount = favValAddsKeys.length;
                                      });
                                      Global.setUserFavList(Global.favoriteValListKey, favValAddsKeys);
                                    },
                                    secondaryBackground: Container(
                                      child: Center(
                                        child: Text(
                                          'Remove',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      color: Colors.red,
                                    ),
                                    background: Container(),
                                    child: Container(
                                      child: ReusableCard(
                                        colour: Colors.white,
                                        cardChild: ListTile(
                                          title: Column(
                                            children: <Widget>[
                                              Text(
                                                favValAdds[item],
                                                style: GoogleFonts.nunito(
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: kHmyTitleTextColor,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                item,
                                                style: GoogleFonts.nunito(
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: kHmyNormalTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            gotoValidatorDetails(item);
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                  )
                : Expanded(
                    child: favDelCount == 0
                        ? Container(
                            padding: EdgeInsets.only(top: 5.0, right: 10.0, left: 10.0),
                            child: Center(
                              child: Text(
                                'No favorites, please add using +',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: kHmyNormalTextColor,
                                ),
                              ),
                            ),
                          )
                        : ListView(
                            children: <Widget>[
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: favDelCount,
                                itemBuilder: (BuildContext context, int ind) {
                                  String item = favDelAddsKeys[ind];
                                  return Dismissible(
                                    key: UniqueKey(),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (DismissDirection direction) {
                                      setState(() {
                                        favDelAddsKeys.removeAt(ind);
                                        favDelCount = favDelAddsKeys.length;
                                      });
                                      Global.setUserFavList(Global.favoriteDelListKey, favDelAddsKeys);
                                    },
                                    secondaryBackground: Container(
                                      child: Center(
                                        child: Text(
                                          'Remove',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      color: Colors.red,
                                    ),
                                    background: Container(),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 1.0),
                                      child: ReusableCard(
                                        colour: Colors.white,
                                        cardChild: ListTile(
                                          title: Column(
                                            children: <Widget>[
                                              Text(
                                                item,
                                                style: GoogleFonts.nunito(
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                  color: kHmyTitleTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            gotoDelegationDetails(item);
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
