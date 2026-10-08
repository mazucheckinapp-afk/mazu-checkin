import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/temple.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notification = NotificationService();
  await notification.initialize();
  final raw = await rootBundle.loadString('assets/temple_data.json');
  final temples = (jsonDecode(raw) as List).map((e) => Temple.fromJson(e as Map<String, dynamic>)).toList();
  runApp(MazuApp(temples: temples, notification: notification));
}
class MazuApp extends StatelessWidget {
  const MazuApp({super.key, required this.temples, required this.notification});
  final List<Temple> temples;
  final NotificationService notification;
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: '大甲媽祖・遶境打卡',
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB74E45)),
      scaffoldBackgroundColor: const Color(0xFFFFF9F2), fontFamily: null),
    home: HomeScreen(temples: temples, notification: notification));
}
