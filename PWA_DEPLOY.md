# 手機版 PWA 部署說明

本專案的 `docs/` 是可直接部署至 GitHub Pages 的網站展示版，不需要 Flutter SDK。

1. 將整個 `mazu-checkin` 資料夾內的內容上傳到 GitHub 儲存庫根目錄。
2. GitHub → Settings → Pages → Build and deployment → Deploy from a branch。
3. 選擇 `main` 與 `/docs`，按 Save。
4. 等候 GitHub Pages 提供 HTTPS 網址，使用手機開啟。
5. Android Chrome：可使用「安裝應用程式」或「加入主畫面」。iPhone Safari：分享 → 加入主畫面。

## 注意

- 這是可安裝的 PWA 網站，不是 APK / IPA；不需經應用程式商店。
- 宮廟清單與操作介面可離線使用（首次需連網）；Google Maps 連結仍需網路。
- 目前打卡為本機瀏覽器模擬紀錄，清除網站資料會失去紀錄；無帳號跨裝置同步。
- GPS 50 公尺提醒、拍照上傳及背景推播尚未在網站版實作，不應誤稱已可用。
- 宮廟位置尚未核實經緯度；Google Maps 為名稱搜尋，不是已驗證定位。
