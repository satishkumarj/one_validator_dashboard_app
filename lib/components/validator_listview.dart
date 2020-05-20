import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validator/components/validator_listtile.dart';
import 'package:validator/models/validator_list_model.dart';

class ValidatorListView extends StatelessWidget {
  ValidatorListView({this.validatorsData});

  final List<ValidatorListModel> validatorsData;

  @override
  Widget build(BuildContext context) {
    int length = validatorsData == null ? 0 : validatorsData.length;
    return ListView.separated(
      itemCount: length,
      itemBuilder: (context, index) {
        ValidatorListModel validatorInfo = validatorsData[index];
        return ValidatorListTile(
          model: validatorInfo,
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
