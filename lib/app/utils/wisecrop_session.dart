
import 'package:shared_preferences/shared_preferences.dart';
class WisecropSession {
  static final WisecropSession _instance = WisecropSession._internal();
  SharedPreferences? prefs;

  // Private constructor
  WisecropSession._internal();

  // Factory constructor to return the singleton instance
  factory WisecropSession() {
    return _instance;
  }

  // Initialization method to load SharedPreferences instance
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future setToken(String stringTime) async {
    var writeData = await prefs!.setString("setToken", stringTime);
    return writeData;
  }
  Future getToken() async {
    var readData = prefs!.getString("setToken");
    return readData ?? "";
  }


}
