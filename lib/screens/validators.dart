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

class ValidatorsScreen extends StatefulWidget {
  ValidatorsScreen({@required this.validatorType});

  final String validatorType;

  @override
  _ValidatorsScreenState createState() => _ValidatorsScreenState();
}

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

  void refreshData() {
    setState(() {
      print('data started loading');
      dataLoading = true;
      noDataReturned = true;
    });
    getAllValidatorData();
    if (validatorType == 'Elected') {}
    refreshSegItems();
  }

  void getAllValidatorData() async {
    NetworkHelper networkHelper = NetworkHelper();
    int i = 0;
    int allValCount;
    if (allValidatorsData == null) {
      allValidatorsData = new List<ValidatorListModel>();
    }
    if (electedValidatorsData == null) {
      electedValidatorsData = new List<ValidatorListModel>();
    }
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
          ValidatorListModel model = ValidatorListModel(
              name: blockData['result'][i]['validator']['name'],
              elected: elected,
              address: address,
              earnings: blockData['result'][i]['lifetime']['reward-accumulated'] / Global.numberToDivide,
              expectedReturn: apr,
              totalStaked: blockData['result'][i]['total-delegation'] / Global.numberToDivide);
          allValidatorsData.add(model);
          if (model.elected) {
            electedValidatorsData.add(model);
          }
        }
        allValidatorsData.sort((a, b) => b.totalStaked.compareTo(a.totalStaked));
        electedValidatorsData.sort((a, b) => b.totalStaked.compareTo(a.totalStaked));
        updateFilteredData();
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Validators'),
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
            : noDataReturned
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
                          color: kHmyTitleTextColor,
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
                          child: ValidatorListView(validatorsData: filteredValidatorData),
                        ),
                      )
                    ],
                  ),
      ),
    );
  }
}
