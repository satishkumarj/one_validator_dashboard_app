import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static double numberToDivide = 1000000000000000000.0;
  static double numberOfSecondsForEpoch = 7.5;
  static int dataRefreshInSeconds = 60;

  static String oneAddressKey = 'MYONEADDRESS';
  static String favoriteListKey = 'FAVORITELIST';

  static String myONEAddress = '';

  static Future<String> getMyONEAddress() async {
    if (Global.myONEAddress == '') {
      Global.myONEAddress = await Global.getUserPreferences(Global.oneAddressKey);
    }
    return Global.myONEAddress;
  }

  static Future<String> getUserPreferences(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key) ?? '';
  }

  static void setUserPreferences(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    if (key != null && value != null) {
      prefs.setString(key, value);
    }
  }

  static Future<List<String>> getUserFavList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? new List<String>();
  }

  static void setUserFavList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    if (key != null && value != null) {
      prefs.setStringList(key, value);
    }
  }

  static void getInitializer() async {
    Firestore.instance.document('initializers/IFmVhDydREL0IjMUnUMa').get().then((doc) {
      numberToDivide = doc['num_to_divide'];
      numberOfSecondsForEpoch = doc['num_seconds_in_epoch'];
      dataRefreshInSeconds = doc['data_refresh_in_secs'];
    });
  }
}
