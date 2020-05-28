import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validator/utilities/globals.dart';

class TotalStakeChartScreen extends StatefulWidget {
  TotalStakeChartScreen({@required this.historyData});

  final Map<String, dynamic> historyData;

  @override
  _TotalStakeChartScreenState createState() => _TotalStakeChartScreenState();
}

class _TotalStakeChartScreenState extends State<TotalStakeChartScreen> {
  Map<String, dynamic> historyData;
  bool dataLoading = false;
  List<charts.Series> seriesList;

  List<charts.Series<TotalStakeHistory, int>> _createData() {
    if (historyData != null) {
      List<TotalStakeHistory> shardsHist = new List<TotalStakeHistory>();
      for (int i = 0; i < historyData.keys.toList().length; i++) {
        String key = historyData.keys.toList()[i];
        double percent = (historyData[key]['total-staking'] / Global.numberToDivide);
        shardsHist.add(new TotalStakeHistory(
          totalStaking: percent.toInt(),
          epochNumber: historyData[key]['current_epoch'],
        ));
      }
      return [
        new charts.Series<TotalStakeHistory, int>(
          id: 'Shards',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          areaColorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.lighter,
          domainFn: (TotalStakeHistory hist, _) => hist.epochNumber,
          measureFn: (TotalStakeHistory hist, _) => hist.totalStaking,
          data: shardsHist,
        ),
      ];
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    historyData = widget.historyData;
    seriesList = _createData();
  }

  @override
  Widget build(BuildContext context) {
    Global.checkIfDarkModeEnabled(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('TOTAL STAKE'),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 35.0, right: 10.0, top: 15.0, bottom: 15.0),
        child: Column(children: <Widget>[
          Expanded(
            child: new charts.LineChart(
              seriesList,
              defaultRenderer: new charts.LineRendererConfig(
                includeArea: true,
                stacked: true,
              ),
              animate: true,
              primaryMeasureAxis: new charts.NumericAxisSpec(
                tickProviderSpec: new charts.BasicNumericTickProviderSpec(zeroBound: true, desiredTickCount: 15),
                renderSpec: charts.SmallTickRendererSpec(
                  labelStyle: new charts.TextStyleSpec(
                    fontSize: 12, // size in Pts.
                    color: Global.isDarkModeEnabled ? charts.MaterialPalette.white : charts.MaterialPalette.black,
                  ),
                ),
              ),
              domainAxis: new charts.NumericAxisSpec(
                tickProviderSpec: new charts.BasicNumericTickProviderSpec(zeroBound: false, desiredTickCount: 12),
                renderSpec: charts.SmallTickRendererSpec(
                  labelRotation: -45,
                  labelAnchor: charts.TickLabelAnchor.before,
                  labelStyle: new charts.TextStyleSpec(
                    fontSize: 12, // size in Pts.
                    color: Global.isDarkModeEnabled ? charts.MaterialPalette.white : charts.MaterialPalette.black,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class TotalStakeHistory {
  final int totalStaking;
  final int epochNumber;
  TotalStakeHistory({this.totalStaking, this.epochNumber});
}
