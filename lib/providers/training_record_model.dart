import 'package:demo_app/models/training_record.dart';
import 'package:demo_app/models/training_record_dao.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrainingRecordModel extends ChangeNotifier {
  final TrainingRecordDao trainingRecordDao = TrainingRecordDao();

  //取得した全てのTrainingRecordを格納するList
  List<TrainingRecord> _trainingRecordList = [];

  //_trainingRecordListを日ごとに振り分けたMap
  Map<DateTime, List<TrainingRecord>> _dailyTrainingRecordMap;

  //ゲッター
  List<TrainingRecord> get trainingRecordList => _trainingRecordList;

  Map<DateTime, List<TrainingRecord>> get dailyTrainingRecordMap =>
      _dailyTrainingRecordMap;

  //取り出したい日時の範囲を格納するためのDateTimeRangeオブジェクト
  DateTimeRange dateTimeRange;

  TrainingRecordModel() {
    _fetchAllTrainingRecords();
  }

  setDateTimeRange({DateTime start, DateTime end}){
    dateTimeRange = DateTimeRange(start: start, end: end);
    print(dateTimeRange);
    notifyListeners();
  }

  _fetchAllTrainingRecords() async {
    _trainingRecordList = await trainingRecordDao.getAllTrainingRecords();
    _getAllDailyTrainingRecordMap();
    DateTime dateTimeNow = DateTime.now();
    dateTimeRange = DateTimeRange(
        start: DateTime(
          dateTimeNow.year,
          dateTimeNow.month,
          dateTimeNow.day,
        ),
        end: DateTime(
            dateTimeNow.add(Duration(days: 1)).year,
            dateTimeNow.add(Duration(days: 1)).month,
            dateTimeNow.add(Duration(days: 1)).day)
    );
    print(dateTimeRange);
    notifyListeners();
  }

  _getAllDailyTrainingRecordMap() async {
    DateFormat dateFormat = DateFormat("yyyy/MM/dd");
    Map<DateTime, List<TrainingRecord>> dailyTrainingRecords = Map();
    print(_trainingRecordList);
    _trainingRecordList.forEach((trainingRecord) {
      DateTime trainingDateTime = DateTime.fromMillisecondsSinceEpoch(
          trainingRecord.dateMillisecondsSinceEpoch);
      DateTime trainingDay = DateTime(
          trainingDateTime.year, trainingDateTime.month, trainingDateTime.day);
      print(trainingDay);
      if (dailyTrainingRecords.containsKey(trainingDay)) {
        dailyTrainingRecords[trainingDay].add(trainingRecord);
      } else {
        dailyTrainingRecords[trainingDay] = [trainingRecord];
      }
    });
    _dailyTrainingRecordMap = dailyTrainingRecords;
    notifyListeners();
  }

  getDailyTrainingRecordMap(
      {Map<DateTime, List<TrainingRecord>> trainingRecordMap,}) {
    Map selectedDailyTrainingRecordMap = Map();
    trainingRecordMap.forEach((key, value) {
      if ((key.isAfter(dateTimeRange.start) || key == dateTimeRange.start) && (key.isBefore(dateTimeRange.end) || key == dateTimeRange.end)) {
        selectedDailyTrainingRecordMap[key] = value;
      }
    });
    print(selectedDailyTrainingRecordMap);
    return selectedDailyTrainingRecordMap;
  }

  void addTrainingRecord(TrainingRecord trainingRecord) async {
    //databaseにTrainingRecordを追加
    Future<int> id = TrainingRecordDao.insertTrainingRecord(
        trainingRecordDao.database, trainingRecord);
    trainingRecord.trainingRecordId = await id;
    _fetchAllTrainingRecords();
  }

  BarChartData getTrainingRecordsChartData() {
    List<BarChartGroupData> trainingRecordsBarGroupList =
        new List<BarChartGroupData>(_trainingRecordList.length);
    _trainingRecordList.asMap().forEach((index, value) {
      trainingRecordsBarGroupList[index] = BarChartGroupData(
        x: value.dateMillisecondsSinceEpoch,
        barRods: [
          BarChartRodData(
              y: value.weight ?? 0.0,
              color: Colors.redAccent,
              borderRadius: BorderRadius.all(Radius.circular(8)))
        ],
      );
    });
    //左側のラベル
    final SideTitles leftTitles = SideTitles(
      showTitles: true,
      textStyle: TextStyle(
          color: const Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 14),
      margin: 20,
      reservedSize: 20,
    );

    //下側のラベル
    final SideTitles bottomTitles = SideTitles(
        showTitles: true,
        textStyle: TextStyle(
            color: const Color(0xff7589a2),
            fontWeight: FontWeight.bold,
            fontSize: 14),
        margin: 15,
        reservedSize: 14,
        getTitles: (value) {
          return DateFormat("MM/dd")
              .format(DateTime.fromMillisecondsSinceEpoch(value.round()));
        });
    final FlTitlesData titlesData = FlTitlesData(
        show: true, leftTitles: leftTitles, bottomTitles: bottomTitles);

    return BarChartData(
      barGroups: trainingRecordsBarGroupList,
      borderData: FlBorderData(show: false),
      titlesData: titlesData,
    );
  }

  double calcMaxRM() {
    List<double> rmList = List.generate(_trainingRecordList.length, (index) {
      return TrainingRecord.calcRM(_trainingRecordList[index]);
    });
    return rmList.reduce(max);
  }
}
