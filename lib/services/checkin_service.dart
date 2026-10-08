import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CheckinService {
  final ImagePicker _picker = ImagePicker();
  Future<Set<String>> completedIds() async =>
      (await SharedPreferences.getInstance()).getStringList('completed_temples')?.toSet() ?? {};
  Future<String?> takePhotoAndCheckIn(String templeId) async {
    final image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 75);
    if (image == null) return null;
    String savedPath = image.path;
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      final destination = path.join(dir.path, 'checkin_${templeId}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      savedPath = (await File(image.path).copy(destination)).path;
    }
    final prefs = await SharedPreferences.getInstance();
    final ids = (prefs.getStringList('completed_temples') ?? []).toSet()..add(templeId);
    await prefs.setStringList('completed_temples', ids.toList());
    await prefs.setString('photo_$templeId', savedPath);
    await prefs.setString('time_$templeId', DateTime.now().toIso8601String());
    return savedPath;
  }
}
