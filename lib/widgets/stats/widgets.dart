import 'dart:math';

import 'package:demo_app/models/training_record.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heatmap_calendar/heatmap_calendar.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

//StatsScreenの達成率を表す円グラフ
Widget achievementRadiusGauge(double value) {
  return SfRadialGauge(
    axes: [
      RadialAxis(
        annotations: [
          GaugeAnnotation(
              positionFactor: 0.1,
              widget: Text(
                "${value.toStringAsFixed(2)}%",
                style: TextStyle(
                    fontWeight: FontWeight.bold),
              ))
        ],
        pointers: [
          RangePointer(
              color: Colors.redAccent,
              animationType: AnimationType.ease,
              value: value,
              sizeUnit: GaugeSizeUnit.factor,
              width: 0.2,
              cornerStyle: CornerStyle.bothCurve),
        ],
        minimum: 0,
        maximum: 100,
        showLabels: false,
        showTicks: false,
        axisLineStyle: AxisLineStyle(
          thickness: 0.2,
          cornerStyle: CornerStyle.bothCurve,
          thicknessUnit: GaugeSizeUnit.factor,
        ),
      )
    ],
    enableLoadingAnimation: true,
    animationDuration: 500,
  );
}

//StatsScreenの進捗を可視化するGithub風ヒートマップ
Widget progressHeatMap(Map dailyTrainingRecords) {
  Map<DateTime, int> inputMap = Map();
  dailyTrainingRecords.forEach((day, trainingRecordList) {
    inputMap[day] = List.generate(trainingRecordList.length, (index){
      return TrainingRecord.calcRM(trainingRecordList[index]).round();
    }).reduce(max);
  });
  return HeatMapCalendar(
    input: inputMap,
    colorThresholds: {
      1: Colors.redAccent[100],
      10: Colors.redAccent[300],
      30: Colors.redAccent[500],
    },
    monthsLabels: [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ],
    squareSize: 20.0,
    textOpacity: 0.3,
    labelTextColor: Colors.blueGrey,
    dayTextColor: Colors.blue[500],
  );
}