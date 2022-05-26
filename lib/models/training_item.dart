class TrainingItem{
  int trainingItemId;
  int trainingTypeId;
  int trainingPartId;
  String trainingName;
  double targetRM;

  TrainingItem({this.trainingItemId, this.trainingTypeId, this.trainingPartId, this.trainingName, this.targetRM});

  Map<String, dynamic> toMap(){
    return {
      "training_item_id": trainingItemId,
      "training_type": trainingTypeId,
      "training_part": trainingPartId,
      "training_name": trainingName,
      "target_rm": targetRM
    };
  }
}