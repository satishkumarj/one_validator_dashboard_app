import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validator/utilities/globals.dart';

class EffectiveMedianChartScreen extends StatefulWidget {
  EffectiveMedianChartScreen({@required this.historyData});

  final Map<String, dynamic> historyData;

  @override
  _EffectiveMedianChartScreenState createState() => _EffectiveMedianChartScreenState();
}

class _EffectiveMedianChartScreenState extends State<EffectiveMedianChartScreen> {
  Map<String, dynamic> historyData;
  bool dataLoading = false;
  List<charts.Series> seriesList;

  List<charts.Series<EffectiveMedianHistory, int>> _createData() {
    if (historyData != null) {
      List<EffectiveMedianHistory> shardsHist = new List<EffectiveMedianHistory>();
      for (int i = 0; i < historyData.keys.toList().length; i++) {
        String key = historyData.keys.toList()[i];
        double percent = double.parse(historyData[key]['effective_median_stake']) / Global.numberToDivide;
        shardsHist.add(new EffectiveMedianHistory(
          effectiveMedian: percent.toInt(),
          epochNumber: historyData[key]['current_epoch'],
        ));
      }
      return [
        new charts.Series<EffectiveMedianHistory, int>(
          id: 'Shards',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          areaColorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.lighter,
          domainFn: (EffectiveMedianHistory hist, _) => hist.epochNumber,
          measureFn: (EffectiveMedianHistory hist, _) => hist.effectiveMedian,
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
        title: Text('EFFECTIVE MEDIAN'),
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

class EffectiveMedianHistory {
  final int effectiveMedian;
  final int epochNumber;
  EffectiveMedianHistory({this.effectiveMedian, this.epochNumber});
}
