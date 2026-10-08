import 'package:geolocator/geolocator.dart';
import '../models/temple.dart';
class GeofenceService {
  static const double radiusMeters = 50;
  Future<Position> currentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('請先開啟手機定位服務');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      throw Exception('未取得定位權限，請至系統設定開啟');
    }
    return Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
  }
  double? distanceMeters(Temple temple, Position position) => temple.hasCoordinates
      ? Geolocator.distanceBetween(position.latitude, position.longitude, temple.latitude!, temple.longitude!)
      : null;
  bool checkTempleProximity(Temple temple, Position position) =>
      (distanceMeters(temple, position) ?? double.infinity) <= radiusMeters;
}
