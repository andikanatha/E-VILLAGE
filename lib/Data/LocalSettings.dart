import 'package:shared_preferences/shared_preferences.dart';

Future<bool> getFingersettings() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool('fingerprint_settings') ?? false;
}

Future<bool> getisDarkTheme() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool('theme') ?? false;
}
