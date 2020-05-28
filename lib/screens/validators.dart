import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:validator/components/validator_listview.dart';
import 'package:validator/models/validator_list_model.dart';
import 'package:validator/utilities/constants.dart';
import 'package:validator/utilities/globals.dart';
import 'package:validator/utilities/networking.dart';

import '../utilities/constants.dart';

class ValidatorsScreen extends StatefulWidget {
  ValidatorsScreen({@required this.validatorType});

  final String validatorType;

  @override
  _ValidatorsScreenState createState() => _ValidatorsScreenState();
}

List choices = [
  SortOptionsPopupMenu(title: 'Sort By:', icon: Icons.home, selected: true),
  SortOptionsPopupMenu(title: 'Expected Return', icon: Icons.home, selected: true),
  SortOptionsPopupMenu(title: 'Total Stake', icon: Icons.bookmark, selected: false),
  SortOptionsPopupMenu(title: 'Uptime', icon: Icons.settings, selected: false),
];

class _ValidatorsScreenState extends State<ValidatorsScreen> {
  TextEditingController editingController = TextEditingController();

  Map<int, Widget> _children;
  List<ValidatorListModel> allValidatorsData;
  List<ValidatorListModel> electedValidatorsData;
  List<ValidatorListModel> filteredValidatorData;
  String validatorType;
  int _currentSelection = 0;
  bool dataLoading = false;
  String filter = '';
  String searchText = '';
  bool noDataReturned = false;
  SortOptionsPopupMenu _selectedChoices = choices[1];

  @override
  void initState() {
    super.initState();
    validatorType = widget.validatorType;
    setState(() {
      if (validatorType == 'Elected') {
        _currentSelection = 0;
      } else {
        _currentSelection = 1;
      }
    });
    refreshData();
  }

  void refreshSegItems() {
    setState(() {
      _children = {
        0: Text('Elected'),
        1: Text('All'),
      };
    });
  }

  Future<void> refreshData() async {
    setState(() {
      noDataReturned = false;
      dataLoading = true;
      print('data started loading');
    });
    if (allValidatorsData == null) {
      allValidatorsData = new List<ValidatorListModel>();
    } else {
      allValidatorsData.clear();
    }
    if (electedValidatorsData == null) {
      electedValidatorsData = new List<ValidatorListModel>();
    } else {
      electedValidatorsData.clear();
    }
    getAllValidatorData();
    if (validatorType == 'Elected') {}
    refreshSegItems();
  }

  void getAllValidatorData() async {
    NetworkHelper networkHelper = NetworkHelper();
    int i = 0;
    int allValCount;
    while (true) {
      var blockData = await networkHelper.getData(kApiMethodGetAllValidatorInformation, i);
      if (blockData != null) {
        allValCount = (blockData['result']).length;
        if (allValCount == 0) {
          setState(() {
            dataLoading = false;
            print('Data loading finished');
          });
          break;
        } else {
          setState(() {
            noDataReturned = false;
          });
        }
        for (int i = 0; i < allValCount; i++) {
          String address = blockData['result'][i]['validator']['address'];
          bool elected = false;
          if (blockData['result'][i]['epos-status'] == 'currently elected') {
            elected = true;
          }
          double apr = double.parse(blockData['result'][i]['lifetime']['apr']) * 100;
          int blocksToSign = blockData['result'][i]['lifetime']['blocks']['to-sign'];
          int blocksSigned = blockData['result'][i]['lifetime']['blocks']['signed'];
          double upTime = 0.0;
          if (blocksToSign != null && blocksSigned != null) {
            if (blocksToSign > 0) {
              upTime = (blocksSigned / blocksToSign) * 100.0;
            } else {
              upTime = 0.0;
            }
          }
          ValidatorListModel model = ValidatorListModel(
              name: blockData['result'][i]['validator']['name'],
              elected: elected,
              address: address,
              earnings: blockData['result'][i]['lifetime']['reward-accumulated'] / Global.numberToDivide,
              expectedReturn: apr,
              uptime: upTime,
              totalStaked: blockData['result'][i]['total-delegation'] / Global.numberToDivide);
          allValidatorsData.add(model);
          if (model.elected) {
            electedValidatorsData.add(model);
          }
        }
        updateFilteredData();
        sortValidators();
        setState(() {
          dataLoading = false;
        });
        i++;
        print(allValidatorsData.length);
      } else {
        setState(() {
          dataLoading = false;
          noDataReturned = false;
        });
        break;
      }
    }
    //print(blockData);
  }

  void sortValidators() {
    if (!dataLoading) {
      if (allValidatorsData != null) {
        if (_selectedChoices.title == 'Expected Return') {
          allValidatorsData.sort((a, b) => b.expectedReturn.compareTo(a.expectedReturn));
        } else if (_selectedChoices.title == 'Total Stake') {
          allValidatorsData.sort((a, b) => b.totalStaked.compareTo(a.totalStaked));
        } else if (_selectedChoices.title == 'Uptime') {
          allValidatorsData.sort((a, b) => b.uptime.compareTo(a.uptime));
        } else {
          allValidatorsData.sort((a, b) => b.totalStaked.compareTo(a.totalStaked));
        }
      }
      if (electedValidatorsData != null) {
        if (_selectedChoices.title == 'Expected Return') {
          electedValidatorsData.sort((a, b) => b.expectedReturn.compareTo(a.expectedReturn));
        } else if (_selectedChoices.title == 'Total Stake') {
          electedValidatorsData.sort((a, b) => b.totalStaked.compareTo(a.totalStaked));
        } else if (_selectedChoices.title == 'Uptime') {
          electedValidatorsData.sort((a, b) => b.uptime.compareTo(a.uptime));
        } else {
          electedValidatorsData.sort((a, b) => b.totalStaked.compareTo(a.totalStaked));
        }
      }
    }
  }

  void updateFilteredData() {
    List<ValidatorListModel> source;
    if (validatorType == 'Elected') {
      source = electedValidatorsData;
    } else {
      source = allValidatorsData;
    }
    setState(() {
      if (searchText.trim() == '') {
        filteredValidatorData = source;
      } else {
        filteredValidatorData = new List<ValidatorListModel>();
        for (int i = 0; i < source.length; i++) {
          ValidatorListModel model = source[i];
          if (model.name.toLowerCase().contains(searchText.toLowerCase())) {
            filteredValidatorData.add(model);
          }
        }
        if (filteredValidatorData.length == 0) {
          noDataReturned = true;
        } else {
          noDataReturned = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Global.checkIfDarkModeEnabled(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Validators'),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        actions: [
          PopupMenuButton(
            elevation: 5,
            initialValue: _selectedChoices,
            onCanceled: () {
              print('You have not chossed anything');
            },
            tooltip: 'Sort By',
            color: kHmyGreyCardColor,
            onSelected: (choice) {
              setState(() {
                if (choice.title != 'Sort By:') {
                  _selectedChoices = choice;
                  sortValidators();
                  updateFilteredData();
                }
              });
            },
            itemBuilder: (BuildContext context) {
              return choices.map((choice) {
                return PopupMenuItem(
                  value: choice,
                  child: Text(choice.title),
                  textStyle: GoogleFonts.nunito(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(
          left: 10.0,
          right: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            MaterialSegmentedControl(
              children: _children,
              selectionIndex: _currentSelection,
              borderColor: Colors.grey,
              selectedColor: _currentSelection == 0 ? kHmyMainColor : kHmyGreyCardColor,
              unselectedColor: Colors.white,
              borderRadius: 32.0,
              onSegmentChosen: (index) {
                setState(() {
                  _currentSelection = index;
                  if (_currentSelection == 0) {
                    validatorType = 'Elected';
                  } else {
                    validatorType = 'All';
                  }
                  updateFilteredData();
                });
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                onChanged: (value) {
                  searchText = value;
                  updateFilteredData();
                },
                controller: editingController,
                decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  hintStyle: GoogleFonts.nunito(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: kHmyNormalTextColor,
                  ),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: noDataReturned
                    ? Container(
                        padding: EdgeInsets.only(top: 30.0, right: 5.0, left: 5.0),
                        child: Center(
                          child: Text(
                            'No Validators found!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      )
                    : dataLoading
                        ? SpinKitDoubleBounce(
                            color: Colors.grey,
                            size: 50.0,
                          )
                        : ValidatorListView(
                            validatorsData: filteredValidatorData,
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

class SortOptionsPopupMenu {
  SortOptionsPopupMenu({this.title, this.icon, this.selected});
  String title;
  IconData icon;
  bool selected;
}
