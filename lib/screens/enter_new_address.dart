import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:validator/utilities/constants.dart';

class EnterNewAddressScreen extends StatefulWidget {
  @override
  _EnterNewAddressScreenState createState() => _EnterNewAddressScreenState();
}

class _EnterNewAddressScreenState extends State<EnterNewAddressScreen> {
  String oneAddress = '';
  String confirmOneAddress = '';
  String validatorName = '';
  String addressFieldHint = '';
  String confirmAddressHint = '';
  bool enterAddressManually = false;
  bool oneAddressFieldEnabled = true;
  bool confirmOneAddressFieldEnabled = false;

  TextEditingController addressController = TextEditingController();
  TextEditingController confirmAddressController = TextEditingController();

  void scanQRCode() async {
    try {
      var result = await BarcodeScanner.scan();
      if (result.type == ResultType.Barcode) {
        if (result.rawContent != '') {
          setState(() {
            oneAddress = result.rawContent;
            print(oneAddress);
          });
        }
      } else if (result.type == ResultType.Error) {
        Alert(context: context, title: "Validators", desc: result.rawContent).show();
      } else {}
    } catch (e) {
      Alert(
              context: context,
              title: "Validators",
              desc:
                  'This application does not have permission to access this device\'s camera, please enable the permission in settings to use QR code Scanner')
          .show();
    }
  }

  void enterAddressManuallyToggled() {
    if (enterAddressManually) {
      setState(() {
        oneAddressFieldEnabled = true;
        confirmOneAddressFieldEnabled = true;
        oneAddress = '';
        confirmOneAddress = '';
      });
    } else {
      setState(() {
        oneAddressFieldEnabled = false;
        confirmOneAddressFieldEnabled = false;
      });
    }
  }

  void saveButtonPress() {
    if (oneAddress == '') {
      String scanOrEnter = 'scan';
      if (enterAddressManually) {
        scanOrEnter = 'enter';
      }
      Alert(context: context, title: "Validators", desc: 'Please $scanOrEnter ONE Address.').show();
      return;
    }
    if (enterAddressManually) {
      if (confirmOneAddress == '') {
        Alert(context: context, title: "Validators", desc: 'Please confirm ONE Address.').show();
        return;
      } else if (oneAddress != confirmOneAddress) {
        Alert(context: context, title: "Validators", desc: 'ONE Addresses are not matching, please verify.').show();
        return;
      }
    }
    Navigator.pop(context, oneAddress);
  }

  @override
  void initState() {
    super.initState();
    enterAddressManually = false;
    oneAddressFieldEnabled = true;
    confirmOneAddressFieldEnabled = false;
    addressFieldHint = 'Please enter ONE address';
    confirmAddressHint = 'Confirm ONE Address';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter ONE Address'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 30.0, right: 10.0, left: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        value: enterAddressManually,
                        onChanged: (value) {
                          setState(() {
                            enterAddressManually = value;
                            enterAddressManuallyToggled();
                          });
                        },
                      ),
                      Text(
                        'Enter ONE address manually',
                        textAlign: TextAlign.center,
                        style: kLabelTextStyle,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      !enterAddressManually
                          ? Flexible(
                              child: Text(
                                oneAddress == '' ? 'Please press QR code button to scan' : oneAddress,
                                style: kLabelTextStyle,
                              ),
                            )
                          : Flexible(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    oneAddress = value;
                                  });
                                },
                                controller: addressController,
                                decoration: InputDecoration(
                                  labelText: "ONE Address",
                                  hintText: "$addressFieldHint",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      enterAddressManually
                          ? SizedBox(
                              width: 1,
                            )
                          : RawMaterialButton(
                              onPressed: () {
                                scanQRCode();
                              },
                              elevation: 3.0,
                              fillColor: kMainColor,
                              child: Icon(
                                FontAwesomeIcons.qrcode,
                                size: 25.0,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(10.0),
                              shape: CircleBorder(),
                            ),
                    ],
                  ),
                ),
                enterAddressManually
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: TextField(
                                onChanged: (value) {
                                  confirmOneAddress = value;
                                },
                                enabled: oneAddressFieldEnabled,
                                controller: confirmAddressController,
                                decoration: InputDecoration(
                                  labelText: "Confirm ONE Address",
                                  hintText: "$addressFieldHint",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        width: 1,
                      ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: RawMaterialButton(
                      onPressed: () {
                        saveButtonPress();
                      },
                      fillColor: kMainColor,
                      constraints: BoxConstraints(minHeight: 50),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      textStyle: TextStyle(fontSize: 16, fontFamily: 'OpenSans', color: Colors.white, fontWeight: FontWeight.w600),
                      child: Text('Save')),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
