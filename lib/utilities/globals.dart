import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validator/models/networks.dart';

class Global {
  static double numberToDivide = 1000000000000000000.0;
  static double numberOfSecondsForEpoch = 7.5;
  static int dataRefreshInSeconds = 60;
  static Map<String, Networks> networks = new Map<String, Networks>();
  static String selectedNetworkUrl = "https://api.s0.t.hmny.io/";
  static String analyticsDataUrl = "https://staking-explorer2-268108.appspot.com/networks/harmony/staking_network_info";
  static String forumUrl = "https://talk.harmony.one";
  static String docsUrl = "https://docs.harmony.one/home/validators";

  static String oneValAddressKey = 'MYONEVALADDRESS';
  static String oneDelAddressKey = 'MYONEVALADDRESS';
  static String favoriteValListKey = 'FAVORITEVALIDATORLIST';
  static String favoriteDelListKey = 'FAVORITEDELEGATORLIST';

  static String myValONEAddress = '';
  static String myDelONEAddress = '';

  static Future<String> getMyValONEAddress() async {
    if (Global.myValONEAddress == '') {
      Global.myValONEAddress = await Global.getUserPreferences(Global.oneValAddressKey);
    }
    return Global.myValONEAddress;
  }

  static Future<String> getMyDelONEAddress() async {
    if (Global.myDelONEAddress == '') {
      Global.myDelONEAddress = await Global.getUserPreferences(Global.oneDelAddressKey);
    }
    return Global.myDelONEAddress;
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

  static Future<void> getInitializer() async {
    Firestore.instance.document('initializers/IFmVhDydREL0IjMUnUMa').get().then((doc) {
      numberToDivide = doc['num_to_divide'];
      numberOfSecondsForEpoch = doc['num_seconds_in_epoch'];
      dataRefreshInSeconds = doc['data_refresh_in_secs'];
      forumUrl = doc['forum_url'];
      docsUrl = doc['docs_url'];
    });
    final QuerySnapshot result = await Firestore.instance.collection('networks').getDocuments();
    final List<DocumentSnapshot> nets = result.documents;
    nets.forEach((network) {
      Global.networks[network['identity']] = Networks(
        identity: network['identity'],
        name: network['name'],
        url: network['url'],
        type: network['type'],
        active: network['active'],
      );
    });
    if (Global.networks['OPEN_STAKING_IDENTITY'].url != null) {
      Global.selectedNetworkUrl = Global.networks['OPEN_STAKING_IDENTITY'].url;
    }
    if (Global.networks['ANALYTICS_DATA_IDENTITY'].url != null) {
      Global.analyticsDataUrl = Global.networks['ANALYTICS_DATA_IDENTITY'].url;
    }
  }
}
