# 手機權限設定

## Android
在 `android/app/src/main/AndroidManifest.xml` 的 `<manifest>` 內加入：
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```
flutter_local_notifications 17.x 需要依其官方文件設定 Android Gradle desugaring、compileSdk 等項目，並依套件版本更新。此專案尚未在 Android/iOS 真機編譯測試。

## iOS
在 `ios/Runner/Info.plist` 加入：
```xml
<key>NSLocationWhenInUseUsageDescription</key><string>用於確認您是否在宮廟 50 公尺內。</string>
<key>NSCameraUsageDescription</key><string>用於拍攝宮廟打卡照片。</string>
<key>NSPhotoLibraryUsageDescription</key><string>用於選取打卡照片。</string>
```

## 下一步
1. 核對每間宮廟的真實經緯度與名稱。
2. 加入背景地理圍欄與通知去重機制，才能達成靠近自動提醒。
3. 若需跨裝置照片上傳與同步，另行接入 Firebase Storage / Firestore 與登入驗證。
4. 若需 APP 內互動地圖及路線，需配置 Google Maps API 金鑰、計費與各平台 SDK。
