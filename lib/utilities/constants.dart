import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color kMainColor = Color(0XFF29C9D8);
const Color kBlueColor = Color(0XFF02008B);
const Color kGreenCardColor = Color(0XFF00E676);
const Color kBlueGreyCardColor = Color(0XFF607D8B);
const Color kLightGrey = Color(0XFFF2F4F8);
const Color kListBackgroundGreen = Color(0XFF66BB6A); // 0XFF4CAF50  //0XFF388E3C #4caf50 //#66bb6a

const kLabelTextStyle = TextStyle(
  fontSize: 15,
  color: Color(0XFF02008B),
  fontWeight: FontWeight.bold,
);

const kDataTextStyle = TextStyle(
  fontSize: 25,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

const kListLabelTextStyle = TextStyle(
  fontSize: 12,
  color: kLightGrey,
  fontWeight: FontWeight.bold,
);

const kListDataTextStyle = TextStyle(
  fontSize: 15,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

const kSectionTitleTextStyle = TextStyle(
  fontSize: 25,
  color: kMainColor,
  fontWeight: FontWeight.bold,
);

const kTextFieldInputDecoration = InputDecoration(
  filled: true,
  fillColor: kLightGrey,
  icon: Icon(
    Icons.search,
    color: Colors.grey,
  ),
  hintText: 'Search Validator',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(15.0),
    ),
    borderSide: BorderSide.none,
  ),
);

const double kNumberToDivide = 1000000000000000000.0;

const kOpenStakeApiUrl = 'https://api.s0.os.hmny.io/';
const kApiMethodGetStakingNetworkInfo = 'hmyv2_getStakingNetworkInfo';
const kApiMethodGetAllValidatorAddresses = 'hmyv2_getAllValidatorAddresses';
const kApiMethodGetElectedValidatorAddresses = 'hmyv2_getElectedValidatorAddresses';
const kApiMethodGetAllValidatorInformation = 'hmyv2_getAllValidatorInformation';
const kApiMethodGetValidatorInformation = 'hmyv2_getValidatorInformation';

final NumberFormat kUSNumberFormat = NumberFormat.simpleCurrency(decimalDigits: 0, locale: 'en_US', name: '');

final NumberFormat kUSPercentageNumberFormat = NumberFormat.simpleCurrency(decimalDigits: 2, locale: 'en_US', name: '');
