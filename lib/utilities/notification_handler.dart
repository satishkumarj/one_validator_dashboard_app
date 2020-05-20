import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:validator/models/notification.dart';
import 'package:validator/utilities/globals.dart';

class OVDNotificationHandler {
  static final _fcm = FirebaseMessaging();
  static final _fdb = Firestore();
  static StreamSubscription<IosNotificationSettings> _iosSubscription;
  static bool backgroundNotificationReceived = false;

  static Future<Database> _getDatabase() async {
    final String databasePath = await getDatabasesPath();
    final Future<Database> database = openDatabase(
      join(databasePath, 'one_validator.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE notifications(id INTEGER PRIMARY KEY, title TEXT, message TEXT, oneAddress TEXT, timeStamp INTEGER)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    return database;
  }

  static Future<String> getDeviceId() async {
    String deviceToken = '';
    deviceToken = await _fcm.getToken();
    return deviceToken;
  }

  static Future<void> createNotificationRecord(String title, String body) async {
    OVDNotification notification = OVDNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      message: body,
      oneAddress: Global.myValONEAddress,
      timeStamp: DateTime.now().millisecondsSinceEpoch,
    );
    final db = await _getDatabase();
    print('database created $db');
    print('before execute insert');
    var result = db.insert("notifications", notification.toJson());
    print('after execute insert');
    print(result);
  }

  static void deleteNotification(int id) async {
    final Database db = await _getDatabase();
    await db.delete(
      'notifications',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  static Future<List<OVDNotification>> getNotifications() async {
    final Database db = await _getDatabase();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("select * from notifications where oneAddress = '${Global.myValONEAddress}'  order by id desc");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return OVDNotification(
        id: maps[i]['id'],
        message: maps[i]['message'],
        title: maps[i]['title'],
        timeStamp: maps[i]['timeStamp'],
        oneAddress: maps[i]['oneAddress'],
      );
    });
  }

  static void registerDevice(String oneAddress, String addressType) {
    if (Platform.isIOS) {
      _iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        _saveDeviceToken(oneAddress, addressType);
      });
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      _saveDeviceToken(oneAddress, addressType);
    }
  }

  static void _saveDeviceToken(String oneAddress, String addressType) async {
    String fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      Firestore.instance.collection('device_tokens_debug').document('$fcmToken:-:$addressType').setData({
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
        'oneAddress': oneAddress,
        'token': fcmToken,
        'addressType': addressType,
      });
    }
  }
}
