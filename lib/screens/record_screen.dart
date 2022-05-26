import 'package:demo_app/models/training_item.dart';
import 'package:demo_app/models/training_record.dart';
import 'package:demo_app/screens/home_screen.dart';
import 'package:demo_app/widgets/base/base_card_tile.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/providers/training_record_model.dart';
import 'package:provider/provider.dart';

class RecordScreen extends StatefulWidget {
  static final String id = "Record";
  final TrainingItem argTrainingItem;

  RecordScreen({this.argTrainingItem});

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  var _weightController = TextEditingController();
  var _countController = TextEditingController();
  var isSelected = [true, false];
  var unitList = ["lbs", "kg"];
  var selectedUnit = "lbs";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //キーボードを表示した際のリサイズを無効にする(キーボードを要素に重ねて表示する).
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          widget.argTrainingItem.trainingName ?? "",
        ),
      ),
      body: roundedWidgetTile(
          context: context, child: _recordWidget(widget.argTrainingItem)),
    );
  }

  Widget _recordWidget(TrainingItem trainingItem) {
    if (trainingItem.trainingTypeId == 1) {
      return _aerobicRecordWidget();
    } else {
      return _anaerobicRecordWidget();
    }
  }

  Widget _aerobicRecordWidget() {
    return Center(child: Text("aerobic record widget"));
  }

  Widget _anaerobicRecordWidget() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          ToggleButtons(
            children: [
              Text("lbs"),
              Text("kg"),
            ],
            onPressed: (int index) {
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < isSelected.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    isSelected[buttonIndex] = true;
                    selectedUnit = unitList[index];
                  } else {
                    isSelected[buttonIndex] = false;
                  }
                }
              });
            },
            isSelected: isSelected,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("重量($selectedUnit)"),
              Spacer(),
              Expanded(
                child: TextField(
                    controller: _weightController,
                    decoration: InputDecoration(
                        hintText: "重量を入力($selectedUnit)",
                        border: OutlineInputBorder()),
                    textAlign: TextAlign.center),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_setValueButton("10", _weightController)],
          ),
          Divider(),
          Row(
            children: [
              Text("回数"),
              Spacer(),
              Expanded(
                child: TextField(
                  controller: _countController,
                  decoration: InputDecoration(
                      hintText: "回数を入力", border: OutlineInputBorder()),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _setValueButton("10", _countController),
            ],
          ),
          Divider(),
          FlatButton(
            child: Text("追加"),
            onPressed: () {
              Provider.of<TrainingRecordModel>(context, listen: false)
                  .addTrainingRecord(TrainingRecord(
                      dateMillisecondsSinceEpoch: DateTime.now()
                          .add(Duration(days: 1))
                          .millisecondsSinceEpoch,
                      trainingItemId: widget.argTrainingItem.trainingItemId,
                      unit: selectedUnit,
                      weight: double.parse(_weightController.text),
                      count: int.parse(_countController.text)));
              Navigator.popUntil(context, ModalRoute.withName(HomeScreen.id));
            },
          ),
        ],
      ),
    );
  }

  static Widget _setValueButton(
      String value, TextEditingController controller) {
    return ButtonTheme(
      minWidth: 50,
      height: 30,
      child: RaisedButton(
        onPressed: () {
          controller.text = value;
        },
        child: Text(
          value,
          style: TextStyle(color: Colors.black),
        ),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        color: Colors.pink,
      ),
    );
  }
}
