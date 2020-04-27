import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static String oneAddressKey = 'MYONEADDRESS';

  static String myONEAddress = 'one1gm8xwupd9e77ja46eaxv8tk4ea7re5zknaauvq';

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
}
