import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHandler {
  static final _fcm = FirebaseMessaging();
  static final _fdb = Firestore();
  static StreamSubscription<IosNotificationSettings> _iosSubscription;

  static Future<String> getDeviceId() async {
    String deviceToken = '';
    deviceToken = await _fcm.getToken();
    return deviceToken;
  }

  static void configureFirebaseListeners() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume $message");
      },
    );
  }

  static void registerDevice(String oneAddress) {
    if (Platform.isIOS) {
      _iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        _saveDeviceToken(oneAddress);
      });
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      _saveDeviceToken(oneAddress);
    }
  }

  static void _saveDeviceToken(String oneAddress) async {
    String fcmToken = await _fcm.getToken();
    print(fcmToken);
    if (fcmToken != null) {
      Firestore.instance.collection('device_tokens').document(fcmToken).setData({
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
        'oneAddress': oneAddress,
        'token': fcmToken,
      });
    }
  }
}
