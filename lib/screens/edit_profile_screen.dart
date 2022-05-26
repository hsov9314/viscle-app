import 'package:demo_app/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  static final String id = "EditProfile";

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //キーボードを表示した際のリサイズを無効にする(キーボードを要素に重ねて表示する).
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(ModalRoute.of(context).settings.arguments),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                    hintText:
                        "${ModalRoute.of(context).settings.arguments}を入力",
                    border: OutlineInputBorder()),
                textAlign: TextAlign.center,
                controller: _valueController,
              ),
              Center(
                child: RaisedButton(
                  child: Text("更新"),
                  onPressed: () {
                    Provider.of<SettingsProvider>(context, listen: false).setSettings(ModalRoute.of(context).settings.arguments, _valueController.text);
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
