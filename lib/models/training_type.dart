class TrainingType{
  int trainingTypeId;
  String trainingTypeName;

  TrainingType({this.trainingTypeId, this.trainingTypeName});

  Map<String, dynamic> toMap(){
    return {
      "training_type_id": trainingTypeId,
      "training_type_name": trainingTypeName,
    };
  }
}