import 'package:demo_app/models/training_item.dart';
import 'package:demo_app/providers/training_item_model.dart';
import 'package:demo_app/providers/training_type_model.dart';
import 'package:demo_app/screens/add_training_screen.dart';
import 'package:demo_app/screens/edit_training_screen.dart';
import 'package:demo_app/screens/record_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectTrainingScreen extends StatefulWidget {
  static final String id = "SelectTraining";

  @override
  _SelectTrainingScreenState createState() => _SelectTrainingScreenState();
}

class _SelectTrainingScreenState extends State<SelectTrainingScreen>
    with SingleTickerProviderStateMixin {
  static final String id = "SelectTraining";
  bool _isEditorMode = false;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this)
      ..addListener(() => setState(() {}));
    _animationController.forward(from: 0.0);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: const Text('トレーニング選択'),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GridView.builder(
                        physics: ScrollPhysics(),
                        itemCount: Provider.of<TrainingItemModel>(context)
                                .trainingItemList
                                .length +
                            (_isEditorMode ? 0 : 1),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0 && !_isEditorMode) {
                            return _addTrainingButton(context);
                          } else {
                            return _trainingCard(
                                Provider.of<TrainingItemModel>(context)
                                        .trainingItemList[
                                    index - (_isEditorMode ? 0 : 1)],
                                index);
                          }
                        }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text(
                          "編集",
                          style: TextStyle(color: Colors.black45),
                        ),
                        shape: StadiumBorder(),
                        onPressed: () {
                          _toggleEditorMode();
                        },
                      ),
                    ),
//                    FlatButton(
//                      child: Text("キャンセル"),
//                      onPressed: () {
//                        Navigator.pop(context);
//                      },
//                    )
                  ],
                )
              ],
            )),
      ),
    );
  }

  Widget _addTrainingButton(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            showModalBottomSheet(
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                context: context,
                builder: (context) {
                  return AddTrainingScreen();
                });
//            final trainingName =
//                await Navigator.pushNamed(context, AddTrainingScreen.id);
          },
        ),
        Text(
          "トレーニングを追加",
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  void _toggleEditorMode() {
    setState(() {
      _isEditorMode = !_isEditorMode;
    });
    _animationController.forward(from: 0);
  }

  Widget _trainingCard(TrainingItem trainingItem, int selectedIndex) {
    if (_isEditorMode) {
      return GestureDetector(
        child: Card(
          child: Stack(children: [
            Text(Provider.of<TrainingTypeModel>(context, listen: false)
                    .getTrainingType(trainingItem.trainingTypeId)
                    .trainingTypeName ??
                ""),
            _editedTrainingCardContent(trainingItem)
          ]),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 8,
        ),
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            context: context,
            builder: (context) {
              return EditTrainingScreen(
                argTrainingItem: trainingItem,
              );
            },
          );
        },
      );
    } else {
      return GestureDetector(
        child: Card(
          child: Stack(children: [
            Text(Provider.of<TrainingTypeModel>(context, listen: false)
                    .getTrainingType(trainingItem.trainingTypeId)
                    .trainingTypeName ??
                ""),
            _defaultTrainingCardContent(trainingItem)
          ]),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 8,
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return RecordScreen(
              argTrainingItem:
                  Provider.of<TrainingItemModel>(context, listen: false)
                      .trainingItemList[selectedIndex - 1],
            );
          }));
        },
      );
    }
  }

  Widget _defaultTrainingCardContent(TrainingItem trainingItem) {
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController, curve: Curves.fastOutSlowIn));
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(trainingItem.trainingName),
        ],
      ),
    );
  }

  Widget _editedTrainingCardContent(TrainingItem trainingItem) {
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController, curve: Curves.fastOutSlowIn));
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                  opacity: animation,
                  child: IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: Text(
                                  "${trainingItem.trainingName}を本当に削除しますか？"),
                              children: [
                                SimpleDialogOption(
                                  child: Text("はい"),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                ),
                                SimpleDialogOption(
                                  child: Text("いいえ"),
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                ),
                              ],
                            );
                          }).then((dialogAnswer) {
                        if (dialogAnswer) {
                          Provider.of<TrainingItemModel>(context, listen: false)
                              .deleteTrainingItem(trainingItem);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ),
        Text(trainingItem.trainingName)
      ],
    );
  }
}
