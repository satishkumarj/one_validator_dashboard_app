import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validator/components/delegation_listtile.dart';
import 'package:validator/models/delegation.dart';

class DelegationsListView extends StatelessWidget {
  DelegationsListView({this.delegationData});

  final List<Delegation> delegationData;

  @override
  Widget build(BuildContext context) {
    int length = delegationData == null ? 0 : delegationData.length;
    return ListView.separated(
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
          color: Colors.white,
          height: 0.0,
        );
      },
    );
  }
}
