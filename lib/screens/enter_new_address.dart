import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:validator/utilities/constants.dart';

class EnterNewAddressScreen extends StatefulWidget {
  EnterNewAddressScreen({this.oneAddressType});
  final String oneAddressType;

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
  int _currentSelection = 0;
  String oneAddressType = '';
  Map<int, Widget> _children;

  TextEditingController addressController = TextEditingController();
  TextEditingController confirmAddressController = TextEditingController();

  void scanQRCode() async {
    try {
      var result = await BarcodeScanner.scan();
      if (result.type == ResultType.Barcode) {
        if (result.rawContent != '') {
          setState(() {
            oneAddress = result.rawContent;
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
    Navigator.pop(context, {'address': oneAddress, 'addressType': oneAddressType});
  }

  void refreshSegItems() {
    setState(() {
      _children = {
        0: Text('Validator Address'),
        1: Text('Delegator Address'),
      };
    });
  }

  @override
  void initState() {
    super.initState();
    oneAddressType = widget.oneAddressType;
    if (oneAddressType == null || oneAddressType == '') {
      oneAddressType = 'Validator';
    }
    refreshSegItems();
    _currentSelection = 0;
    if (oneAddressType == 'Delegator') {
      _currentSelection = 1;
    }
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
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
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
                        style: GoogleFonts.nunito(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: kHmyTitleTextColor,
                        ),
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
                                style: GoogleFonts.nunito(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: kHmyTitleTextColor,
                                ),
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
                              fillColor: kHmyMainColor,
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
                      fillColor: kHmyMainColor,
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
