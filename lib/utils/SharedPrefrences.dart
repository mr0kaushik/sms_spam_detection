import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static final String _kImportedKey = "imported_key";
  static final String _kOnBoardScreen = "on_board_screen";

  /// GET Imported Key has been pressed or not
  static Future<bool> isMessageImported() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kImportedKey) ?? false;
  }

  /// SET Imported Key
  static Future<bool> setAlreadyImported(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_kImportedKey, value);
  }

  /// GET Imported Key has been pressed or not
  static Future<bool> isOnBoardedGone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kOnBoardScreen) ?? false;
  }

  /// SET Imported Key
  static Future<bool> setOnBoardedGone(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_kOnBoardScreen, value);
  }
}
