import 'package:demo_app/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreenTab extends StatelessWidget {
  static final String id = "Profile";

  //final SharedPreferences settingPrefs = await SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount:
              Provider.of<SettingsProvider>(context).settings.settingsData.keys.toList().length,
          itemBuilder: (BuildContext context, int index) {
            return _trainingRecordListTile(
                context,
                Provider.of<SettingsProvider>(context).settings.settingsData.values.toList()[index],
                Provider.of<SettingsProvider>(context).settings.settingsNameMap.keys.toList()[index],
                Provider.of<SettingsProvider>(context).settings.settingsNameMap.values.toList()[index]);
          }),
    );
  }

  Widget _trainingRecordListTile(
      BuildContext context, String settingsValue, String settingsNameKey, String settingsNameValue) {
    return ListTile(
      //leading: Icon(Icons.directions_run),
      title: Text(settingsValue == "" ? "未設定" : settingsValue,
          style: TextStyle(color: Colors.black, fontSize: 18.0)),
      subtitle: Text(
        settingsNameValue,
        style: TextStyle(fontSize: 12),
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pushNamed(context, EditProfileScreen.id, arguments: settingsNameKey);
      },
    );
  }
}
