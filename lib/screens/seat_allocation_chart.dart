import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeatsAllocationChartScreen extends StatefulWidget {
  SeatsAllocationChartScreen({@required this.historyData});

  final Map<String, dynamic> historyData;

  @override
  _SeatsAllocationChartScreenState createState() => _SeatsAllocationChartScreenState();
}

class _SeatsAllocationChartScreenState extends State<SeatsAllocationChartScreen> {
  Map<String, dynamic> historyData;
  bool dataLoading = false;
  List<charts.Series> seriesList;

  List<charts.Series<ShardsHistory, int>> _createData() {
    if (historyData != null) {
      List<ShardsHistory> shardsHist = new List<ShardsHistory>();
      for (int i = 0; i < historyData.keys.toList().length; i++) {
        String key = historyData.keys.toList()[i];
        double percent = 0.0;
        if (historyData[key]['total_seats'] > 0) {
          percent = ((historyData[key]['total_seats_used'] / historyData[key]['total_seats']) * 100);
        }
        shardsHist.add(new ShardsHistory(
          numberOfShards: percent.toInt(),
          epochNumber: historyData[key]['current_epoch'],
        ));
      }
      return [
        new charts.Series<ShardsHistory, int>(
          id: 'Shards',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          areaColorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.lighter,
          domainFn: (ShardsHistory hist, _) => hist.epochNumber,
          measureFn: (ShardsHistory hist, _) => hist.numberOfShards,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('SEATS ALLOCATION'),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Container(
        color: Colors.white,
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
              ),
              domainAxis: new charts.NumericAxisSpec(
                tickProviderSpec: new charts.BasicNumericTickProviderSpec(zeroBound: false, desiredTickCount: 15),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class ShardsHistory {
  final int numberOfShards;
  final int epochNumber;
  ShardsHistory({this.numberOfShards, this.epochNumber});
}
