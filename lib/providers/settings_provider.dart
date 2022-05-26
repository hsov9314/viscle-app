import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo_app/models/settings.dart';

class SettingsProvider extends ChangeNotifier {
  Settings _settings;

  Settings get settings => _settings;

  getSettings(String key) async {
    SharedPreferences settingsPref = await SharedPreferences.getInstance();
    String value = settingsPref.get(key);
    return value;
  }

  setSettings(String key, String value) async {
    _settings.setSettingsValue(key, value);
    notifyListeners();

    SharedPreferences settingsPref = await SharedPreferences.getInstance();
    Future<bool> setStringFuture = settingsPref.setString(key, value);
    setStringFuture.then((value) {
      Future<SharedPreferences> future = SharedPreferences.getInstance();
      future.then((value) {
        String stringFuture = value.getString(key);
      });
    });
  }

  SettingsProvider() {
    _setup();
  }

  void _setup() async {
    _settings = Settings();
    Future<SharedPreferences> futureSetupPrefs = SharedPreferences.getInstance();
    futureSetupPrefs.then((tmpSharedPreferences){
      _settings.settingsData.forEach((key, value) {
        _settings.setSettingsValue(key, tmpSharedPreferences.getString(key));
      });
      notifyListeners();
    });
  }
}
