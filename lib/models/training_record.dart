import 'package:flutter/cupertino.dart';

class TrainingRecord{
  static double lbsConversionCoefficient = 2.205;
  int trainingRecordId;
  int trainingItemId;
  int dateMillisecondsSinceEpoch;
  String trainingName;
  String unit;
  double weight;
  int count;
  int time;

  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      "training_record_id": trainingRecordId,
      "training_record_item": trainingItemId,
      "date": dateMillisecondsSinceEpoch,
      "unit": unit,
      "weight": weight,
      "count": count,
      "time": time
    };
  }

  TrainingRecord({this.trainingRecordId, this.trainingItemId, this.dateMillisecondsSinceEpoch, this.unit, this.weight, this.count, this.time});

  //TrainingRecordのRMを求めるメソッド
  static double calcRM(TrainingRecord trainingRecord){
    if(trainingRecord.unit == "lbs"){
      trainingRecord.weight /= lbsConversionCoefficient;
    }
    return trainingRecord.weight * (1 + (trainingRecord.count / 40));
  }

  //TrainingRecordの総重量を求めるメソッド
  static double calcTotalWeight(TrainingRecord trainingRecord){
    if(trainingRecord.unit == "lbs"){
      trainingRecord.weight /= lbsConversionCoefficient;
    }
    return trainingRecord.weight * trainingRecord.count;
  }

  //TrainingRecordのリストから総重量の総和を求めるメソッド
  static double calcDailyTotalWeight(List<TrainingRecord> trainingRecordList){
    double totalWeight = 0.0;
    trainingRecordList.forEach((trainingRecord) {
      totalWeight += calcTotalWeight(trainingRecord);
    });
    return totalWeight;
  }
}