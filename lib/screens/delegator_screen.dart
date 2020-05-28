import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validator/components/delegations_listview.dart';
import 'package:validator/models/delegation.dart';
import 'package:validator/utilities/constants.dart';
import 'package:validator/utilities/globals.dart';
import 'package:validator/utilities/networking.dart';

import '../utilities/globals.dart';

class DelegationDetailsScreen extends StatefulWidget {
  DelegationDetailsScreen({this.oneAddress});
  final String oneAddress;
  @override
  _DelegationDetailsScreenState createState() => _DelegationDetailsScreenState();
}

class _DelegationDetailsScreenState extends State<DelegationDetailsScreen> {
  String name = 'Delegators';
  String delegatorAddress;
  int delegationCount = 0;
  List<Delegation> delegationData;
  bool hasData = false;
  bool dataLoading = true;

  Future<void> refreshData() async {
    dataLoading = true;
    NetworkHelper networkHelper = NetworkHelper();
    int i = 0;
    int allValCount;
    if (delegationData == null) {
      delegationData = new List<Delegation>();
    } else {
      delegationData.clear();
    }
    var blockData = await networkHelper.getData(kApiMethodGetDelegationsByDelegator, delegatorAddress);
    setState(() {
      dataLoading = false;
    });
    if (blockData != null) {
      allValCount = (blockData['result']).length;
      if (allValCount == 0) {
        setState(() {
          hasData = false;
          print('Data loading finished');
        });
      } else {
        setState(() {
          hasData = true;
        });
      }
      for (int i = 0; i < allValCount; i++) {
        String valAddress = blockData['result'][i]['validator_address'];
        String delAddress = blockData['result'][i]['delegator_address'];
        String valName = valAddress;
        if (Global.validatorNames[valAddress] != null) {
          valName = Global.validatorNames[valAddress];
          if (valName == '') {
            valName = valAddress;
          }
        }
        double amount = blockData['result'][i]['amount'] / Global.numberToDivide;
        double reward = blockData['result'][i]['reward'] / Global.numberToDivide;
        setState(() {
          if (delAddress != valAddress) {
            delegationData.add(Delegation(
              delegateAddress: delAddress,
              validatorAddress: valAddress,
              validatorName: valName,
              amount: amount,
              reward: reward,
            ));
          }
        });
      }
    } else {
      setState(() {
        dataLoading = false;
        hasData = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    delegatorAddress = widget.oneAddress;
    hasData = false;
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    Global.checkIfDarkModeEnabled(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Delegations'),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(
          left: 10.0,
          right: 10.0,
        ),
        child: dataLoading
            ? SpinKitDoubleBounce(
                color: Colors.grey,
                size: 50.0,
              )
            : !hasData
                ? Container(
                    padding: EdgeInsets.only(top: 30.0, right: 10.0, left: 10.0),
                    child: Center(
                      child: Text(
                        'No Delegations found!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      SelectableText(
                        'Delegator Address :\n${this.delegatorAddress}',
                        style: GoogleFonts.nunito(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: DelegationsListView(
                            delegationData: delegationData,
                            refreshData: refreshData,
                          ),
                        ),
                      )
                    ],
                  ),
      ),
    );
  }
}
