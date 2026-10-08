import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/temple.dart';
import '../services/checkin_service.dart';
import '../services/geofence_service.dart';
import '../services/notification_service.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.temples, required this.notification});
  final List<Temple> temples;
  final NotificationService notification;
  @override State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final _checkins = CheckinService();
  final _geo = GeofenceService();
  final _search = TextEditingController();
  Set<String> completed = {};
  String city = '全部';
  bool busy = false;
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { final ids = await _checkins.completedIds(); if (mounted) setState(() => completed = ids); }
  void _message(String text) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text))); }
  Future<void> _checkin(Temple temple) async {
    if (busy) return;
    if (!temple.hasCoordinates) { _message('此宮廟尚未核實 GPS 座標，暫不能進行距離驗證打卡。'); return; }
    setState(() => busy = true);
    try {
      final position = await _geo.currentPosition();
      final distance = _geo.distanceMeters(temple, position)!;
      if (distance > GeofenceService.radiusMeters) {
        _message('距離 ${distance.toStringAsFixed(0)} 公尺，請接近 50 公尺內再打卡'); return;
      }
      await widget.notification.sendCheckInNotification(temple.name);
      final photo = await _checkins.takePhotoAndCheckIn(temple.id);
      if (photo == null) { _message('已取消拍照，未完成打卡'); return; }
      await _load();
      _message('🎉 ${temple.name} 打卡成功！');
    } catch (e) { _message('無法打卡：$e'); }
    finally { if (mounted) setState(() => busy = false); }
  }
  Future<void> _map(Temple temple) async {
    final query = Uri.encodeComponent('${temple.city}${temple.district}${temple.name}');
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) _message('無法開啟地圖');
  }
  @override Widget build(BuildContext context) {
    final shown = widget.temples.where((t) => (city == '全部' || t.city == city) &&
      ('${t.name}${t.district}${t.city}'.contains(_search.text.trim()))).toList();
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF9F3835), foregroundColor: Colors.white,
        title: const Text('🏮 大甲媽祖・遶境打卡')),
      body: Column(children: [
        Container(width: double.infinity, padding: const EdgeInsets.all(22), color: const Color(0xFFFFE9D4),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('跟著媽祖走，沿途留下美好回憶', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('已完成 ${completed.length} / ${widget.temples.length} 間宮廟'),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: widget.temples.isEmpty ? 0 : completed.length / widget.temples.length,
              minHeight: 9, borderRadius: BorderRadius.circular(12)),
            const SizedBox(height: 8),
            const Text('📍 GPS 50 公尺驗證  ·  📷 拍照紀錄', style: TextStyle(fontSize: 12)),
          ])),
        Padding(padding: const EdgeInsets.all(12), child: TextField(controller: _search,
          onChanged: (_) => setState(() {}), decoration: const InputDecoration(prefixIcon: Icon(Icons.search),
          hintText: '搜尋宮廟、鄉鎮', border: OutlineInputBorder()))),
        SizedBox(height: 48, child: ListView(scrollDirection: Axis.horizontal,
          children: ['全部', ...{for (final t in widget.temples) t.city}].map((c) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4), child: ChoiceChip(label: Text(c), selected: city == c,
            onSelected: (_) => setState(() => city = c)))).toList())),
        Expanded(child: ListView.builder(itemCount: shown.length, itemBuilder: (context, i) {
          final t = shown[i]; final done = completed.contains(t.id);
          return Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5), child: Padding(
            padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Icon(done ? Icons.verified : Icons.temple_buddhist, color: const Color(0xFFB64B40)),
                const SizedBox(width: 8), Expanded(child: Text(t.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                if (done) const Text('已打卡 ✓', style: TextStyle(color: Colors.green))]),
              Text('${t.city}・${t.district}${t.notes.isEmpty ? '' : '・${t.notes}'}'),
              if (!t.hasCoordinates) const Text('座標待確認｜尚未開放 GPS 打卡',
                style: TextStyle(color: Colors.deepOrange, fontSize: 12)),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton.icon(onPressed: () => _map(t), icon: const Icon(Icons.map_outlined), label: const Text('查看地圖')),
                FilledButton.icon(onPressed: busy || done ? null : () => _checkin(t),
                  icon: const Icon(Icons.camera_alt_outlined), label: Text(done ? '已完成' : '拍照打卡'))])])));
        }))
      ]),
    );
  }
  @override void dispose() { _search.dispose(); super.dispose(); }
}
