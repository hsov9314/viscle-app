import 'package:demo_app/models/training_item.dart';
import 'package:demo_app/models/training_item_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrainingItemModel extends ChangeNotifier {
  final TrainingItemDao trainingItemDao = TrainingItemDao();
  List<TrainingItem> _trainingItemList = [];

  List<TrainingItem> get trainingItemList => _trainingItemList;

  TrainingItemModel() {
    fetchAllTrainingItems();
  }

  fetchAllTrainingItems() async {
    _trainingItemList = await trainingItemDao.getAllTrainingItems();
    notifyListeners();
  }

  addTrainingItem(TrainingItem trainingItem) async {
    //databaseにTrainingItemを追加
    trainingItemDao.insertTrainingItem(trainingItem);
    fetchAllTrainingItems();
  }

  TrainingItem getTrainingItem(int id){
    return _trainingItemList.where((item)=>(item.trainingItemId == id)).toList()[0];
  }

  updateTrainingItem(TrainingItem trainingItem) async{
    trainingItemDao.updateTrainingItem(trainingItem);
    fetchAllTrainingItems();
  }

  deleteTrainingItem(TrainingItem trainingItem) async {
    trainingItemDao.deleteTrainingItem(trainingItem);
    fetchAllTrainingItems();
  }

  isDuplicated(String trainingName) {
    return List.generate(_trainingItemList.length, (index) {
      return _trainingItemList[index].trainingName;
    }).contains(trainingName);
  }
}
