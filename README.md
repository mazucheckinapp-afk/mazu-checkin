# 🏮 大甲媽祖遶境 GPS 智慧打卡

包含 Flutter 手機 APP 原始碼，以及 `web-demo/` 瀏覽器互動展示版。

## 啟動 Flutter

1. 安裝 Flutter SDK / Android Studio，確認 `flutter doctor`。
2. 在本資料夾執行 `flutter create --platforms=android,ios,web .` 產生原生平台檔案（已存在的 lib 程式碼請保留）。
3. 執行 `flutter pub get`。
4. Android：參照 `SETUP.md` 加入定位、相機、通知權限。iOS 同理。
5. 執行 `flutter run`。

## 資料與限制

`assets/temple_data.json` 由使用者提供的《大甲媽祖.pdf》整理，總計 32 間。**PDF 未提供經緯度**，所有座標皆為 null；請在正式啟用打卡前逐筆查證與補入。宮廟名稱及路線不代表已核實的官方年度遶境資訊。現階段定位與 50m 驗證僅在使用者按下打卡時執行；不包含背景 geofencing，亦無雲端照片上傳。Web 照片儲存僅作示範，手機版本會複製到 App 文件目錄。

## GitHub Pages 展示版

GitHub Repository → Settings → Pages → Build and deployment → Deploy from a branch → main /docs。網站展示版使用瀏覽器本地儲存模擬打卡，**不代表真實 GPS 驗證**。
