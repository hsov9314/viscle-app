import 'package:demo_app/models/training_part.dart';
import 'package:demo_app/models/training_part_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrainingPartModel extends ChangeNotifier {
  final TrainingPartDao trainingPartDao = TrainingPartDao();
  List<TrainingPart> _trainingPartList = [];
  TrainingPart dropDownTrainingPart;

  List<TrainingPart> get trainingPartList => _trainingPartList;

  TrainingPartModel() {
    fetchAllTrainingParts();
  }

  fetchAllTrainingParts() async {
    _trainingPartList = await trainingPartDao.getAllTrainingParts();
    dropDownTrainingPart = _trainingPartList[0];
    notifyListeners();
  }

  setDropDownTrainingPart(TrainingPart trainingPart){
    dropDownTrainingPart = trainingPart;
    notifyListeners();
  }
}
