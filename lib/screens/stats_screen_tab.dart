import 'package:demo_app/widgets/stats/widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demo_app/providers/training_record_model.dart';
import 'package:demo_app/models/training_record.dart';
import 'package:demo_app/widgets/base/base_card_tile.dart';

class StatsScreenTab extends StatelessWidget {
  static final String id = "Stats";
  final double targetRM = 30;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Color(0xf56a79).withOpacity(0.9),
                    Color(0xff414d).withOpacity(0.9),
                  ],
                  stops: const [
                    0.1,
                    0.9,
                  ],
                ),
              ),
              height: 65,
              width: 500,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "統計",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: roundedWidgetTile(
                  context: context,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        child: Container(
                            height: 130,
                            width: 130,
                            child: achievementRadiusGauge(6
//                                Provider.of<TrainingRecordModel>(context)
//                                        .calcMaxRM() /
//                                    targetRM),
                                )),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "達成率",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "RM",
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      )
                    ],
                  )),
            ),
//                roundedWidgetTile(
//                  context: context,
//                  child: FutureBuilder(
//                    future: (Provider.of<TrainingRecordModel>(context)
//                        .dailyTrainingRecordMap),
//                    builder: (BuildContext context, AsyncSnapshot snapshot) {
//                      if (snapshot.hasData) {
//                        return progressHeatMap(snapshot.data);
//                      } else {
//                        return Text("no data");
//                      }
//                    },
//                  ),
//                ),
            Padding(
              padding: EdgeInsets.all(15),
              child: roundedWidgetTile(
                  context: context,
                  child: BarChart(Provider.of<TrainingRecordModel>(context)
                      .getTrainingRecordsChartData())),
            ),
          ],
        )
      ],
    );
  }

  Widget _trainingRecordListTile(TrainingRecord tmpTrainingRecord) {
    return ListTile(
      leading: Icon(Icons.directions_run),
      title: Text(tmpTrainingRecord.trainingName ?? "",
          style: TextStyle(color: Colors.black, fontSize: 18.0)),
      subtitle: Text(
          '${tmpTrainingRecord.weight.toString()}${tmpTrainingRecord.unit}*${tmpTrainingRecord.count.toString()}'),
    );
  }
}
