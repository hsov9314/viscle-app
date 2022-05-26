class TrainingPart{
  int trainingPartId;
  String trainingPartName;

  TrainingPart({this.trainingPartId, this.trainingPartName});

  Map<String, dynamic> toMap(){
    return {
      "training_part_id": trainingPartId,
      "training_part_name": trainingPartName,
    };
  }
}