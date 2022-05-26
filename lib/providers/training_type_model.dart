import 'package:demo_app/models/training_type.dart';
import 'package:demo_app/models/training_type_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrainingTypeModel extends ChangeNotifier {
  final TrainingTypeDao trainingTypeDao = TrainingTypeDao();
  List<TrainingType> _trainingTypeList = [];
  TrainingType dropDownTrainingType;

  List<TrainingType> get trainingTypeList => _trainingTypeList;

  TrainingTypeModel() {
    fetchAllTrainingTypes();
  }

  fetchAllTrainingTypes() async {
    _trainingTypeList = await trainingTypeDao.getAllTrainingTypes();
    dropDownTrainingType = _trainingTypeList[0];
    notifyListeners();
  }

  TrainingType getTrainingType(int id) {
    TrainingType trainingType;
    _trainingTypeList.forEach((element) {
      if (element.trainingTypeId == id) {
        trainingType = element;
      }
    });
    return trainingType;
  }

  setDropDownTrainingType(TrainingType trainingType) {
    dropDownTrainingType = trainingType;
    notifyListeners();
  }
}
