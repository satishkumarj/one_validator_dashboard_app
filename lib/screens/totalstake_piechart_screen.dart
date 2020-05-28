import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validator/models/validator.dart';
import 'package:validator/utilities/constants.dart';

import '../utilities/globals.dart';

class TotalStakeScreen extends StatefulWidget {
  TotalStakeScreen({@required this.model});

  final Validator model;

  @override
  _TotalStakeScreenState createState() => _TotalStakeScreenState();
}

class _TotalStakeScreenState extends State<TotalStakeScreen> {
  Validator validator;
  bool dataLoading = false;
  List<charts.Series> seriesList;

  @override
  void initState() {
    super.initState();
    validator = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    Global.checkIfDarkModeEnabled(context);
    var data = [
      new LinearDelegation('Self', validator.selfStake),
    ];
    if (validator.delegatedStake > 0) {
      data.add(
        new LinearDelegation('Delegated', validator.delegatedStake),
      );
    }
    seriesList = [
      new charts.Series<LinearDelegation, String>(
        id: 'Sales',
        domainFn: (LinearDelegation del, _) => del.type,
        measureFn: (LinearDelegation del, _) => del.amount,
        data: data,
        // Set a label accessor to control the text of the arc label.
      )
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('${validator.name} \'s Total Stake'),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Column(children: <Widget>[
          Expanded(
            child: new charts.PieChart(
              seriesList,
              animate: true,
              behaviors: [
                new charts.DatumLegend(
                  // Positions for "start" and "end" will be left and right respectively
                  // for widgets with a build context that has directionality ltr.
                  // For rtl, "start" and "end" will be right and left respectively.
                  // Since this example has directionality of ltr, the legend is
                  // positioned on the right side of the chart.
                  position: charts.BehaviorPosition.top,
                  // By default, if the position of the chart is on the left or right of
                  // the chart, [horizontalFirst] is set to false. This means that the
                  // legend entries will grow as new rows first instead of a new column.
                  horizontalFirst: false,
                  // This defines the padding around each legend entry.
                  cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                  // Set [showMeasures] to true to display measures in series legend.
                  showMeasures: true,
                  // Configure the measure value to be shown by default in the legend.
                  legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
                  // Optionally provide a measure formatter to format the measure value.
                  // If none is specified the value is formatted as a decimal.
                  measureFormatter: (num value) {
                    return value == null ? '-' : '${kUSNumberFormat.format(value)}';
                  },
                ),
              ],
              defaultRenderer: new charts.ArcRendererConfig(
                arcRendererDecorators: [new charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.outside)],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class LinearDelegation {
  final String type;
  final double amount;

  LinearDelegation(this.type, this.amount);
}
