import 'package:validator/components/list_view_item.dart';
import 'package:validator/components/resuable_card.dart';
import 'package:validator/models/validator.dart';
import 'package:validator/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/delegation.dart';
import '../utilities/constants.dart';

class DelegatorDetailsScreen extends StatefulWidget {
  DelegatorDetailsScreen({@required this.model});

  final Validator model;

  @override
  _DelegatorDetailsScreenState createState() => _DelegatorDetailsScreenState();
}

class _DelegatorDetailsScreenState extends State<DelegatorDetailsScreen> {
  Validator validator;
  bool dataLoading = false;

  @override
  void initState() {
    super.initState();
    validator = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> delegatorItems = new List<Widget>();
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
      );
      delegatorItems.add(item);
      SizedBox sb = SizedBox(height: 1);
      delegatorItems.add(sb);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('${validator.name} \'s Delegators'),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(5),
          children: <Widget>[
            Text(
              'Delegators',
              style: kSectionTitleTextStyle,
            ),
            ReusableCard(
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: delegatorItems,
              ),
              colour: kMainColor.withAlpha(20),
            ),
          ],
        ),
      ),
    );
  }
}
