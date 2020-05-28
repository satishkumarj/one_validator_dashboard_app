import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validator/components/delegation_listtile.dart';
import 'package:validator/models/delegation.dart';

import '../utilities/globals.dart';

class DelegationsListView extends StatelessWidget {
  DelegationsListView({this.delegationData, this.refreshData});

  final List<Delegation> delegationData;
  final Function refreshData;

  @override
  Widget build(BuildContext context) {
    int length = delegationData == null ? 0 : delegationData.length;
    return RefreshIndicator(
      onRefresh: refreshData,
      child: ListView.separated(
        itemCount: length,
        itemBuilder: (context, index) {
          Delegation del = delegationData[index];
          return DelegationListTile(
            model: del,
            context: context,
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Global.isDarkModeEnabled ? Colors.black : Colors.white,
            height: 0.0,
          );
        },
      ),
    );
  }
}
