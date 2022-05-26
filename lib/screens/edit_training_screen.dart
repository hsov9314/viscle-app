import 'package:demo_app/models/training_item.dart';
import 'package:demo_app/providers/training_item_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditTrainingScreen extends StatefulWidget {
  static final String id = "EditTraining";
  final TrainingItem argTrainingItem;
  EditTrainingScreen({this.argTrainingItem});

  @override
  _EditTrainingScreenState createState() => _EditTrainingScreenState();
}

class _EditTrainingScreenState extends State<EditTrainingScreen> {
  final _formKey = GlobalKey<FormState>();
  var _trainingNameController = TextEditingController();

  @override
  void initState() {
    _trainingNameController.text = widget.argTrainingItem.trainingName;
    super.initState();
  }

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
            title: Center(child: Text("トレーニング編集")),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      widget.argTrainingItem.trainingName = _trainingNameController.text;
                      Provider.of<TrainingItemModel>(context, listen: false)
                          .updateTrainingItem(widget.argTrainingItem);
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
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: TextFormField(
                      controller: _trainingNameController,
                      maxLength: 30,
                      decoration: InputDecoration(
                          hoverColor: Colors.redAccent,
                          fillColor: Colors.redAccent,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.redAccent[100], width: 2.0),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.redAccent, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          hintText: "トレーニング名を入力",
                          border: OutlineInputBorder(),
                          suffixIcon: _getClearButton()),
                      textAlign: TextAlign.center,
                      validator: (value) {
                        return _validateTrainingName(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _validateTrainingName(String trainingName){
    if(trainingName.length == 0){
      return "トレーニング名を入力してください";
    }
    else if (Provider.of<TrainingItemModel>(context, listen: false)
        .isDuplicated(trainingName)) {
      return "入力されたトレーニング名は既に使用されています";
    }
    return null;
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
