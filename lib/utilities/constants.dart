import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color kHmyMainColor = Color(0XFF00AEE9); //Color(0XFF29C9D8);
const Color kHmyBlueColor = Color(0XFF1B295E);
const Color kHmyGreenCardColor = Color(0XFF69FABD);
const Color kHmyGreyCardColor = Color(0XFF758796);
const Color kLightGrey = Color(0XFFF2F4F8);
const Color kListBackgroundGreen = Color(0XFF66BB6A); // 0XFF4CAF50  //0XFF388E3C #4caf50 //#66bb6a
const Color kListViewItemColor = Color(0XFF77D3F3);

const Color kHmyTitleTextColor = Color(0XFF1B295E);
const Color kHmyNormalTextColor = Color(0XFF758796);

const kTextFieldInputDecoration = InputDecoration(
  filled: true,
  fillColor: kLightGrey,
  icon: Icon(
    Icons.search,
    color: Colors.grey,
  ),
  hintText: 'Search Validator',
  hintStyle: TextStyle(
    color: kHmyGreyCardColor,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(15.0),
    ),
    borderSide: BorderSide.none,
  ),
);

const kApiMethodGetStakingNetworkInfo = 'hmyv2_getStakingNetworkInfo';
const kApiMethodGetAllValidatorAddresses = 'hmyv2_getAllValidatorAddresses';
const kApiMethodGetElectedValidatorAddresses = 'hmyv2_getElectedValidatorAddresses';
const kApiMethodGetAllValidatorInformation = 'hmyv2_getAllValidatorInformation';
const kApiMethodGetValidatorInformation = 'hmyv2_getValidatorInformation';
const kApiMethodGetDelegationsByDelegator = 'hmyv2_getDelegationsByDelegator';
const kApiMethodBlockNumber = 'hmyv2_blockNumber';
const kGetPriceONEBTCBinance = "https://api.binance.com/api/v3/ticker/price?symbol=ONEBTC";
const kGetPriceBTCUSDTBinance = "https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT";

final NumberFormat kUSNumberFormat = NumberFormat.simpleCurrency(decimalDigits: 0, locale: 'en_US', name: '');
final NumberFormat kLongDecimalNumberFormat = NumberFormat.simpleCurrency(decimalDigits: 8, locale: 'en_US', name: '');
final NumberFormat kUSPercentageNumberFormat = NumberFormat.simpleCurrency(decimalDigits: 2, locale: 'en_US', name: '');
