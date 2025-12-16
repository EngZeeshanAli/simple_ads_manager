# ✅ simple_ads_manager

### Google Mobile Ads (AdMob) Made Simple for Flutter

A clean, centralized, and production-ready Ads Manager for Flutter apps using **Google Mobile Ads (
AdMob)**.

---

## ✅ Platform Support

| Android | iOS |
|:-------:|:---:|
|    ✅    |  ✅  |

---

## ✨ Features

- Banner Ads
- Native Ads (Template based)
- Interstitial Ads
- Rewarded Ads
- Rewarded Interstitial Ads
- App Open Ads
- Auto App Open (Lifecycle based)
- Revenue callbacks
- Clean & fluent API

---

## 📦 Installation

```yaml
dependencies:
  simple_ads_manager: ^0.0.2
```

## 📢 Supported Ad Formats

| Ad Type               | Description                 |
|-----------------------|-----------------------------|
| Banner                | Standard banner ads         |
| Native                | Template based native ads   |
| Interstitial          | Fullscreen ads              |
| Rewarded              | Reward based fullscreen ads |
| Rewarded Interstitial | Fullscreen + reward         |
| App Open              | Ads shown on app start      |
| Auto App Open         | Ads shown on app resume     |

---

# 🚀 Usage

Follow the steps below to integrate ads in **minutes**.

---

## Step 1️⃣ Add Dependency

```yaml
dependencies:
  simple_ads_manager: ^0.0.2
````

---

## Step 2️⃣ AdMob App ID Setup

### Android (`AndroidManifest.xml`)

```xml

<meta-data android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="REPLACE_WITH_YOUR_ANDROID_APP_ID" />
```

### iOS (`Info.plist`)

```xml

<key>GADApplicationIdentifier</key><string>SAMPLE_APP_ID</string>
```

---

## Step 3️⃣ Initialize Ads (Once)

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SimpleAdsManager.instance.initAdsManager(
    // Android
    bannerAndroid: "ca-app-pub-xxx",
    interstitialAndroid: "ca-app-pub-xxx",
    rewardedAndroid: "ca-app-pub-xxx",
    rewardedInterstitialAndroid: "ca-app-pub-xxx",
    nativeAndroid: "ca-app-pub-xxx",
    appOpenAndroid: "ca-app-pub-xxx",

    // iOS
    bannerIOS: "ca-app-pub-xxx",
    interstitialIOS: "ca-app-pub-xxx",
    rewardedIOS: "ca-app-pub-xxx",
    rewardedInterstitialIOS: "ca-app-pub-xxx",
    nativeIOS: "ca-app-pub-xxx",
    appOpenIOS: "ca-app-pub-xxx",
  );

  SimpleAdsManager.instance.enableAds(
    banner: true,
    native: true,
    interstitial: true,
    rewarded: true,
    rewardedInterstitial: true,
    appOpen: true,
  );

  runApp(const MyApp());
}
```

---

## Step 4️⃣ Show Ads

### 🟢 Banner Ad

```dart
SimpleAdsManager.instance.banner
(
onLoaded: () {},
onRevenue: (revenue) {},
);
```

---

### 🟢 Interstitial Ad

```dart
SimpleAdsManager.instance.interstitial
(
context: context,
onDismiss: (adShown) {},
onRevenue: (revenue) {},
);
```

---

### 🟢 Rewarded Ad

```dart
SimpleAdsManager.instance.rewarded
(
context: context,
onRewarded: (reward, adShown) {},
onRevenue: (revenue) {},
);
```

---

### 🟢 Rewarded Interstitial Ad

```dart
SimpleAdsManager.instance.rewardedInterstitial
(
context: context,
onRewarded: (reward, adShown) {},
onRevenue: (revenue) {},
);
```

---

### 🟢 App Open Ad

```dart
SimpleAdsManager.instance.appOpen
(
context: context,
onDismiss: (adShown) {},
onRevenue: (revenue) {},
);
```

---

### 🟢 Auto App Open (Recommended)

Automatically shows App Open ads when app resumes.

```dart
SimpleAdsManager.instance.autoAppOpen
(
context: context,
onDismiss: (adShown) {},
onRevenue: (revenue) {},
);
```

---

### 🟢 Native Ad

```dart
import 'package:simple_ads_manager/simple_ads_manager.dart';

SimpleAdsManager.instance.native
(
nativeTemplateStyle: NativeTemplateStyle(
templateType: TemplateType.medium,
mainBackgroundColor: Colors.white,
cornerRadius: 10,
callToActionTextStyle: NativeTemplateTextStyle(
textColor: Colors.white,
backgroundColor: Colors.blue,
size: 16,
),
primaryTextStyle: NativeTemplateTextStyle(
textColor: Colors.black,
size: 14,
),
secondaryTextStyle: NativeTemplateTextStyle(
textColor: Colors.grey,
size: 12,
),
),
onLoaded: () {},
onRevenue: (revenue) {},
);
```

---

## 🔍 Check Ad Availability

```dart

bool ready =
SimpleAdsManager.instance.isAvailable(AdType.interstitial);
```

---

## ⚠️ Best Practices

* Initialize ads before usage
* Use test ads during development
* Avoid showing ads back-to-back
* Always check availability
* Follow AdMob policies

---

## 👨‍💻 Author

**Eng. Zeeshan Ali**  
Senior Software Engineer  
Flutter • Android • iOS  
Google Mobile Ads Specialist

---

## 📄 License

MIT License © 2025 Zeeshan Ali

```
