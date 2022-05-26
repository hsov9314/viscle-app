class Settings {
  final Map settingsNameMap = {
    "name": "名前",
    "age": "年齢",
    "height": "身長",
    "weight": "体重",
  };

  Map _settingsData = {
    "name": "",
    "age": "",
    "height": "",
    "weight": "",
  };

  Settings(){}

  Map get settingsData => _settingsData;

  setSettingsValue(String key, String value){
    _settingsData[key] = value;
  }

  getSettingsValue(String key){
    return _settingsData[key];
  }
}
