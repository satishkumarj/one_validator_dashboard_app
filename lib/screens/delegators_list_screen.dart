import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validator/components/list_view_item.dart';
import 'package:validator/components/resuable_card.dart';
import 'package:validator/models/validator.dart';
import 'package:validator/screens/delegator_screen.dart';
import 'package:validator/utilities/constants.dart';

import '../models/delegation.dart';
import '../utilities/constants.dart';
import '../utilities/globals.dart';

class DelegatorDetailsScreen extends StatefulWidget {
  DelegatorDetailsScreen({@required this.model, this.refreshData});

  final Validator model;
  final Function refreshData;

  @override
  _DelegatorDetailsScreenState createState() => _DelegatorDetailsScreenState();
}

class _DelegatorDetailsScreenState extends State<DelegatorDetailsScreen> {
  Validator validator;
  bool dataLoading = false;
  List<Widget> delegatorItems = new List<Widget>();
  Function refreshDelegations;

  @override
  void initState() {
    super.initState();
    refreshDelegations = widget.refreshData;
    refreshData();
  }

  void refreshData() {
    validator = widget.model;
    List<Widget> delItems = new List<Widget>();
    validator.delegations.sort((a, b) => b.amount.compareTo(a.amount));
    for (int i = 0; i < validator.delegations.length; i++) {
      Delegation d = validator.delegations[i];
      String address = d.delegateAddress;
      if (validator.address == d.delegateAddress) {
        address = '${d.delegateAddress} (self)';
      }
      ListViewItem item = ListViewItem(
        title: address,
        text: kUSNumberFormat.format(d.amount),
        moreDetails: true,
        openMoreDetails: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DelegationDetailsScreen(
                oneAddress: address,
              ),
            ),
          );
        },
      );
      delItems.add(item);
      SizedBox sb = SizedBox(height: 1);
      delItems.add(sb);
    }
    setState(() {
      delegatorItems = delItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    Global.checkIfDarkModeEnabled(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${validator.name} \'s Delegators'),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Container(
        child: RefreshIndicator(
          onRefresh: refreshDelegations,
          child: ListView(
            padding: const EdgeInsets.all(5),
            children: <Widget>[
              Text(
                'Delegators',
                style: GoogleFonts.nunito(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              ReusableCard(
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: delegatorItems,
                ),
                colour: kHmyMainColor.withAlpha(20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
