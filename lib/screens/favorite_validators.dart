import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:validator/models/validator_list_model.dart';
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
  int favCount = 0;
  List<String> favAddsKeys = new List<String>();
  Map<String, String> favAdds = new Map<String, String>();

  void scanQRCode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnterNewAddressScreen(),
      ),
    );
    if (result != null) {
      if (result != '') {
        String favAddress = result;
        print(favAddress);
        NetworkHelper networkHelper = NetworkHelper();
        var blockData = await networkHelper.getData(kApiMethodGetValidatorInformation, favAddress);
        print(blockData);
        if (blockData != null) {
          if (blockData["error"] != null) {
            String error = blockData['error']['message'];
            if (error.contains('not found address in current state')) {
              error = 'No validator found with $result address in current state';
            }
            Alert(context: context, title: "Validators", desc: error).show();
          } else {
            String validatorName = blockData['result']['validator']['name'];
            Global.setUserPreferences(favAddress, validatorName);
            setState(() {
              if (favAdds[favAddress] == null) {
                favAdds[favAddress] = validatorName;
                favAddsKeys.add(favAddress);
                favCount = favAddsKeys.length;
              }
            });
            Global.setUserFavList(Global.favoriteListKey, favAddsKeys);
          }
        }
      }
    }
  }

  void getFavAddressList() async {
    favAddsKeys = await Global.getUserFavList(Global.favoriteListKey);
    Map<String, String> favAddKeysAndNames = new Map<String, String>();
    for (int i = 0; i < favAddsKeys.length; i++) {
      String add = favAddsKeys[i];
      favAddKeysAndNames[add] = await Global.getUserPreferences(add);
    }
    setState(() {
      favAdds = favAddKeysAndNames;
      favCount = favAddsKeys.length;
    });
  }

  void gotoValidatorDetails(String address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ValidatorDetails(
          model: ValidatorListModel(name: favAdds[address], address: address),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getFavAddressList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
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
      body: favCount == 0
          ? Container(
              padding: EdgeInsets.only(top: 30.0, right: 10.0, left: 10.0),
              child: Center(
                child: Text(
                  'No favorites, please add using +',
                  textAlign: TextAlign.center,
                  style: kTextStyleError,
                ),
              ),
            )
          : Container(
              child: ListView(
                children: <Widget>[
                  ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: favCount,
                    itemBuilder: (BuildContext context, int index) {
                      String item = favAddsKeys[index];
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (DismissDirection direction) {
                          setState(() {
                            favAddsKeys.removeAt(index);
                            favCount = favAddsKeys.length;
                          });
                          Global.setUserFavList(Global.favoriteListKey, favAddsKeys);
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
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: ListTile(
                            title: Column(
                              children: <Widget>[
                                Text(
                                  favAdds[item],
                                  style: kListDataTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  item,
                                  style: kLabelTextStyle,
                                ),
                              ],
                            ),
                            onTap: () {
                              gotoValidatorDetails(item);
                            },
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: kListViewItemColor,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
