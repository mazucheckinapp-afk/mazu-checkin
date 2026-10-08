import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;
  Future<void> initialize() async {
    if (kIsWeb) return;
    const settings = InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings());
    _ready = await _plugin.initialize(settings) ?? false;
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
  }
  Future<void> sendCheckInNotification(String templeName) async {
    if (!_ready) return;
    await _plugin.show(templeName.hashCode & 0x7fffffff, '媽祖遶境・抵達提醒',
      '您已接近 $templeName（50 公尺內），可以拍照打卡囉！',
      const NotificationDetails(android: AndroidNotificationDetails('temple_arrival', '宮廟抵達提醒',
        channelDescription: '接近宮廟時提醒打卡', importance: Importance.high, priority: Priority.high),
        iOS: DarwinNotificationDetails()));
  }
}
