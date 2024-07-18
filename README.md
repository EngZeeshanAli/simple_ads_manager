# ✅ simple_ads_manager

# Google Mobile Ads for Flutter Using AdMob

## Platform Support

| Android | iOS |
|:-------:|:---:|
|    ✅    |  ✅  |

# Usage

Follow the easy and fast 4 steps to use the package.

## Step 1: Add the package to your project

```yaml
dependencies:
  simple_ads_manager: ^0.0.2
```

## Step 2: Ad Units
1. Create a json file in the assets folder [(download json file)](https://drive.usercontent.google.com/u/0/uc?id=1XSdZcvLzZ_LkH1Tp66XB6P7WhA3rDpKS&export=download)
2. Add `<meta-data>` to the `AndroidManifest.xml` file
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="REPLACE_WITH_YOUR_APP_ID"/>
```
3. Add `GADApplicationIdentifier` to the `Info.plist` file for IOS
```xml
<key>GADApplicationIdentifier</key>
<string>REPLACE_WITH_YOUR_APP_ID</string>
```


## Step 3: Initialize the plugin

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SimpleAdsManager.instance.setAdUnits("ads.json");
  await SimpleAdsManager.instance.init(appOpen: true, interstitial: true, rewarded: true);
  runApp(const MyApp());
}
```

## Step 4: Show Ads

```dart
//show banner 
SimpleAdsManager.instance.showBanner()

//show interstitial
SimpleAdsManager.instance.showInterstitialAd(context, () => {})

//show rewarded
SimpleAdsManager.instance.showRewardedAd(context, (reward) => {});

// show app open
SimpleAdsManager.instance.showAppOpenAd(context, () => {});

// show app open on app resume
SimpleAdsManager.instance.enableAutoAppOpenAdFeature(context);

```

# Author

[<img src="https://scontent.flhe5-1.fna.fbcdn.net/v/t39.30808-6/300559864_1436774140119711_6792763069085736620_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=a5f93a&_nc_eui2=AeEsk-GblO_jJANgp-_UhJaNgEfEczKricGAR8RzMquJwW2u-H-TgOSLeqFm2gSOududzskIX_jdxREko_2yBI8k&_nc_ohc=Je8MFXkbW-8Q7kNvgFUBu93&_nc_pt=1&_nc_ht=scontent.flhe5-1.fna&oh=00_AYDsSi9PKkNf83SyTNXvS68FXdZb1lSdh6b_nbQnY54pJw&oe=669EEF49" width="250"/>](image.png)
## Eng. Zeeshan Ali

