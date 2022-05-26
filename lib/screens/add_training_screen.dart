import 'package:demo_app/models/training_item.dart';
import 'package:demo_app/models/training_part.dart';
import 'package:demo_app/models/training_type.dart';
import 'package:demo_app/providers/training_item_model.dart';
import 'package:demo_app/providers/training_part_model.dart';
import 'package:demo_app/providers/training_type_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTrainingScreen extends StatefulWidget {
  static final String id = "AddTraining";

  @override
  _AddTrainingScreenState createState() => _AddTrainingScreenState();
}

class _AddTrainingScreenState extends State<AddTrainingScreen> {
  final _formKey = GlobalKey<FormState>();
  var _trainingNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Center(child: Text("トレーニング追加")),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      final TrainingType selectedTrainingType =
                          Provider.of<TrainingTypeModel>(context, listen: false)
                              .dropDownTrainingType;
                      final TrainingPart selectedTrainingPart =
                          Provider.of<TrainingPartModel>(context, listen: false)
                              .dropDownTrainingPart;
                      var trainingItem;
                      if (selectedTrainingType.trainingTypeName == "有酸素") {
                        trainingItem = TrainingItem(
                            trainingName: _trainingNameController.text,
                            trainingTypeId:
                                selectedTrainingType.trainingTypeId);
                      } else {
                        trainingItem = TrainingItem(
                            trainingName: _trainingNameController.text,
                            trainingTypeId: selectedTrainingType.trainingTypeId,
                            trainingPartId:
                                selectedTrainingPart.trainingPartId);
                      }
                      Provider.of<TrainingItemModel>(context, listen: false)
                          .addTrainingItem(trainingItem);
                      Navigator.pop(context, _trainingNameController.text);
                    }
                  },
                ),
              )
            ],
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
          ),
          body: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _getTrainingItemFieldWidgets(
                    Provider.of<TrainingTypeModel>(context)
                        .dropDownTrainingType),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _validateTrainingName(String trainingName) {
    if (trainingName.length == 0) {
      return "トレーニング名を入力してください";
    } else if (Provider.of<TrainingItemModel>(context, listen: false)
        .isDuplicated(trainingName)) {
      return "入力されたトレーニング名は既に使用されています";
    }
    return null;
  }

  List<Widget> _getTrainingItemFieldWidgets(TrainingType trainingType) {
    if (trainingType.trainingTypeName == "有酸素") {
      return [_trainingTypeDropDownMenu(), _getTrainingItemNameTextField()];
    } else {
      return [
        _trainingTypeDropDownMenu(),
        _getTrainingPartDropDownMenu(),
        _getTrainingItemNameTextField()
      ];
    }
  }

  Widget _trainingTypeDropDownMenu() {
    return Row(
      children: [
        Text("種類"),
        DropdownButton(
            value: Provider.of<TrainingTypeModel>(context).dropDownTrainingType,
            icon: Icon(Icons.arrow_drop_down),
            hint: Text("種類を選択"),
            onChanged: (value) {
              Provider.of<TrainingTypeModel>(context, listen: false)
                  .setDropDownTrainingType(value);
            },
            items: List.generate(
                Provider.of<TrainingTypeModel>(context).trainingTypeList.length,
                (index) {
              return DropdownMenuItem(
                value: Provider.of<TrainingTypeModel>(context)
                    .trainingTypeList[index],
                child: Text(Provider.of<TrainingTypeModel>(context)
                    .trainingTypeList[index]
                    .trainingTypeName),
              );
            })),
      ],
    );
  }

  Widget _getTrainingPartDropDownMenu() {
    return Row(
      children: [
        Text("部位"),
        DropdownButton(
            value: Provider.of<TrainingPartModel>(context).dropDownTrainingPart,
            icon: Icon(Icons.arrow_drop_down),
            hint: Text("部位を選択"),
            onChanged: (value) {
              Provider.of<TrainingPartModel>(context, listen: false)
                  .setDropDownTrainingPart(value);
            },
            items: List.generate(
                Provider.of<TrainingPartModel>(context).trainingPartList.length,
                (index) {
              return DropdownMenuItem(
                value: Provider.of<TrainingPartModel>(context)
                    .trainingPartList[index],
                child: Text(Provider.of<TrainingPartModel>(context)
                    .trainingPartList[index]
                    .trainingPartName),
              );
            })),
      ],
    );
  }

  Widget _getTrainingItemNameTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: TextFormField(
        controller: _trainingNameController,
        maxLength: 30,
        decoration: InputDecoration(
            hoverColor: Colors.redAccent,
            fillColor: Colors.redAccent,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent[100], width: 2.0),
              borderRadius: BorderRadius.circular(30.0),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.redAccent, width: 2.0),
                borderRadius: BorderRadius.circular(10.0)),
            hintText: "トレーニング名を入力",
            border: OutlineInputBorder(),
            suffixIcon: _getClearButton()),
        textAlign: TextAlign.center,
        validator: (value) {
          return _validateTrainingName(value);
        },
      ),
    );
  }

  Widget _getClearButton() {
    if (_trainingNameController.text.length == 0) {
      return null;
    } else {
      return IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (_trainingNameController.text.length > 0) {
            _trainingNameController.clear();
          }
        },
      );
    }
  }
}
