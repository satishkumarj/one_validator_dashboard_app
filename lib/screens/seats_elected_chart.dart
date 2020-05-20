import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validator/utilities/constants.dart';

class SeatsElectedChartScreen extends StatefulWidget {
  SeatsElectedChartScreen({@required this.data, this.totalSeats, this.electedSeats});

  final List<dynamic> data;
  final int totalSeats;
  final int electedSeats;

  @override
  _SeatsElectedChartScreenState createState() => _SeatsElectedChartScreenState();
}

class _SeatsElectedChartScreenState extends State<SeatsElectedChartScreen> {
  List<dynamic> data;
  int electedSeats = 0;
  int totalSeats = 0;
  bool dataLoading = false;
  List<charts.Series> seriesList;

  List<charts.Series<Shards, String>> _createData() {
    if (data != null) {
      if (data.length > 0) {
        final totalValidators = [
          new Shards('Shard 0', data[0]['total']),
          new Shards('Shard 1', data[1]['total']),
          new Shards('Shard 2', data[2]['total']),
          new Shards('Shard 3', data[3]['total']),
        ];

        final electedValidators = [
          new Shards('Shard 0', data[0]['external']),
          new Shards('Shard 1', data[1]['external']),
          new Shards('Shard 2', data[2]['external']),
          new Shards('Shard 3', data[3]['external']),
        ];
        return [
          new charts.Series<Shards, String>(
            id: 'Total',
            domainFn: (Shards shard, _) => shard.shardId,
            measureFn: (Shards shard, _) => shard.validatorCount,
            data: totalValidators,
          ),
          new charts.Series<Shards, String>(
            id: 'Elected',
            domainFn: (Shards shard, _) => shard.shardId,
            measureFn: (Shards shard, _) => shard.validatorCount,
            data: electedValidators,
          ),
        ];
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    data = widget.data;
    totalSeats = widget.totalSeats;
    electedSeats = widget.electedSeats;
    seriesList = _createData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SEATS ELECTED $electedSeats / $totalSeats'),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: seriesList == null
          ? Container(
              padding: EdgeInsets.only(top: 30.0, right: 10.0, left: 10.0),
              child: Center(
                child: Text(
                  'No Data!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: kHmyTitleTextColor,
                  ),
                ),
              ),
            )
          : Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: Column(children: <Widget>[
                Expanded(
                  child: new charts.BarChart(
                    seriesList,
                    animate: true,
                    barGroupingType: charts.BarGroupingType.stacked,
                  ),
                ),
              ]),
            ),
    );
  }
}

class Shards {
  final String shardId;
  final int validatorCount;

  Shards(this.shardId, this.validatorCount);
}
