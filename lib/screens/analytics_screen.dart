import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validator/components/resuable_card.dart';
import 'package:validator/screens/effective_median_chart.dart';
import 'package:validator/screens/seat_allocation_chart.dart';
import 'package:validator/screens/seats_elected_chart.dart';
import 'package:validator/screens/total_stake_chart.dart';
import 'package:validator/utilities/constants.dart';
import 'package:validator/utilities/globals.dart';
import 'package:validator/utilities/networking.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final List<String> analytics = ['Seats Elected', 'Seat Allocation', 'Total Stake', 'Effective Meadian'];
  bool _dataError = false;
  int totalSeats = 0;
  int electedSeats = 0;
  List<dynamic> shardsData = new List<dynamic>();
  Map<String, dynamic> historyData = new Map<String, dynamic>();

  void getAnalyticsData() async {
    print('Data loading started');
    _dataError = false;
    NetworkHelper networkHelper = NetworkHelper();
    var blockData = await networkHelper.getDataFromUrl(Global.analyticsDataUrl);
    if (blockData != null) {
      if (blockData["error"] != null) {
        _dataError = true;
      }
      if (blockData['externalShards'] != null) {
        shardsData = blockData['externalShards'];
      }
      if (blockData['history'] != null) {
        historyData = blockData['history'];
      }
      if (blockData['total_seats'] != null) {
        totalSeats = blockData['total_seats'];
      }
      if (blockData['total_seats_used'] != null) {
        electedSeats = blockData['total_seats_used'];
      }
    } else {
      _dataError = true;
    }
  }

  void gotoSeatsElectedScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeatsElectedChartScreen(
          data: shardsData,
          electedSeats: electedSeats,
          totalSeats: totalSeats,
        ),
      ),
    );
  }

  void gotoSeatsAllocationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeatsAllocationChartScreen(
          historyData: historyData,
        ),
      ),
    );
  }

  void gotoTotalStakeChartScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TotalStakeChartScreen(
          historyData: historyData,
        ),
      ),
    );
  }

  void gotoEffectiveMedianChartScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EffectiveMedianChartScreen(
          historyData: historyData,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getAnalyticsData();
  }

  @override
  Widget build(BuildContext context) {
    Global.checkIfDarkModeEnabled(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: analytics.length,
              itemBuilder: (BuildContext context, int index) {
                String item = analytics[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                  child: ReusableCard(
                    cardChild: ListTile(
                      trailing: Icon(
                        FontAwesomeIcons.chevronRight,
                        color: kHmyGreyCardColor,
                        size: 20.0,
                      ),
                      leading: Icon(
                        FontAwesomeIcons.solidChartBar,
                        color: kHmyMainColor,
                        size: 20.0,
                      ),
                      title: Text(
                        item,
                        style: GoogleFonts.nunito(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      onTap: () {
                        switch (index) {
                          case 0:
                            gotoSeatsElectedScreen();
                            break;
                          case 1:
                            gotoSeatsAllocationScreen();
                            break;
                          case 2:
                            gotoTotalStakeChartScreen();
                            break;
                          case 3:
                            gotoEffectiveMedianChartScreen();
                            break;
                          default:
                            break;
                        }
                      },
                    ),
                    colour: Global.isDarkModeEnabled ? Colors.black : Colors.white,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
