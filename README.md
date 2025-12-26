# simple_ads_manager

### Google Mobile Ads (AdMob) Made Simple for Flutter

A clean, centralized, and production-ready ads manager for Flutter apps using **Google Mobile Ads (AdMob)**.

---

## ✅ Platform Support

| Android | iOS |
|:-------:|:---:|
|   ✅    | ✅  |

---

## ✨ Supported Ad Formats

| Ad Type               | Preload Support | Revenue Callback | Lifecycle Aware |
|-----------------------|-----------------|------------------|-----------------|
| Banner                | ❌               | ✅                | Inline          |
| Native (Template)     | ❌               | ✅                | Inline          |
| Interstitial          | ✅               | ✅                | Manual          |
| Rewarded              | ❌               | ✅                | Manual          |
| Rewarded Interstitial | ✅               | ✅                | Manual          |
| App Open              | ❌               | ✅                | Foreground      |
| Auto App Open         | ❌               | ✅                | Automatic       |



## ✨ Features

- Banner Ads
- Native Ads (Template-based)
- Interstitial Ads (Preload support)
- Rewarded Ads
- Rewarded Interstitial Ads
- App Open Ads
- Auto App Open (Lifecycle-based)
- Revenue callbacks
- Availability checks
- Cooldown control

---

# 📦 Installation

```yaml
dependencies:
  simple_ads_manager: ^0.0.2
```

Run:

```bash
flutter pub get
```

---

# ⚙️ Setup

## 1️⃣ Add AdMob App ID

### Android → `AndroidManifest.xml`

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="REPLACE_WITH_YOUR_ANDROID_APP_ID" />
```

### iOS → `Info.plist`

```xml
<key>GADApplicationIdentifier</key>
<string>REPLACE_WITH_YOUR_IOS_APP_ID</string>
```

---

## 2️⃣ Initialize SDK

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SimpleAdsManager.instance.init();
  runApp(const MyApp());
}
```

---

## 3️⃣ Optional: Enable Test Ads

```dart
SimpleAdsManager.alwaysTestADs = true;
```

---

# 🔥 Usage

---

## 🟢 Banner Ad

```dart
SimpleAdsManager.instance.banner(
  adUnitId: "ca-app-pub-xxxxxxxxxxxxxxxx/banner-id",
);
```

---

## 🟢 Native Ad

```dart
SimpleAdsManager.instance.nativeAd(
  adUnitId: "ca-app-pub-xxxxxxxxxxxxxxxx/native-id",
  nativeTemplateStyle: NativeTemplateStyle(
    templateType: TemplateType.medium,
  ),
);
```

---

## 🟢 Interstitial (Recommended: Preload)

### Preload

```dart
SimpleAdsManager.instance.preloadInterstitial(
  adUnitId: "ca-app-pub-xxxxxxxxxxxxxxxx/interstitial-id",
);
```

### Show

```dart
SimpleAdsManager.instance.showPreloadedInterstitial(
  context: context,
  adUnitId: "ca-app-pub-xxxxxxxxxxxxxxxx/interstitial-id",
  onDismiss: (shown) {},
);
```

---

## 🟢 Rewarded

```dart
SimpleAdsManager.instance.loadAndShowRewarded(
  adUnitId: "ca-app-pub-xxxxxxxxxxxxxxxx/rewarded-id",
  context: context,
  onCompleted: (reward, earned) {},
);
```

---

## 🟢 Rewarded Interstitial

```dart
SimpleAdsManager.instance.loadAndShowRewardedInterstitial(
  adUnitId: "ca-app-pub-xxxxxxxxxxxxxxxx/rewarded-interstitial-id",
  context: context,
);
```

---

## 🟢 App Open

```dart
SimpleAdsManager.instance.loadAndShowAppOpen(
  adUnitId: "ca-app-pub-xxxxxxxxxxxxxxxx/app-open-id",
  context: context,
);
```

---

## 🟢 Auto App Open (Best Practice)

```dart
SimpleAdsManager.instance.showAppStateAppOpen(
  adUnitId: "ca-app-pub-xxxxxxxxxxxxxxxx/app-open-id",
  context: context,
);
```

---

## 🧠 Check Ad Availability

```dart
bool ready =
    SimpleAdsManager.instance.isInterstitialReady;
```

---

# 💡 Best Practices

- Initialize SDK before showing ads.
- Preload fullscreen ads for better UX.
- Avoid showing ads back-to-back.
- Use natural transition points.
- Always use test ads during development.
- Follow AdMob policies strictly.

---

## 👨‍💻 Author

**Eng. Zeeshan Ali**  
Senior Software Engineer  
Flutter • Android • iOS  
Google Mobile Ads Specialist

---

## 📄 License

MIT License © 2025 Zeeshan Ali
