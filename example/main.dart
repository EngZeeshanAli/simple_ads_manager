import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/simple_ads_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ads manager
  await SimpleAdsManager.instance.initAdsManager(
    bannerAndroid: "YOUR_BANNER_ANDROID",
    interstitialAndroid: "YOUR_INTERSTITIAL_ANDROID",
    rewardedAndroid: "YOUR_REWARDED_ANDROID",
    rewardedInterstitialAndroid: "YOUR_REWARDED_INTERSTITIAL_ANDROID",
    nativeAndroid: "YOUR_NATIVE_ANDROID",
    appOpenAndroid: "YOUR_APP_OPEN_ANDROID",
    bannerIOS: "YOUR_BANNER_IOS",
    interstitialIOS: "YOUR_INTERSTITIAL_IOS",
    rewardedIOS: "YOUR_REWARDED_IOS",
    rewardedInterstitialIOS: "YOUR_REWARDED_INTERSTITIAL_IOS",
    nativeIOS: "YOUR_NATIVE_IOS",
    appOpenIOS: "YOUR_APP_OPEN_IOS",
  );

  // Enable the ads you want
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Enable automatic app open ads on resume
    SimpleAdsManager.instance.autoAppOpen(context: context);

    return MaterialApp(
      title: 'Flutter Ads Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Ads Demo"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text("Banner Ad:"),
              // Show Banner Ad
              SimpleAdsManager.instance.banner(),

              const SizedBox(height: 20),
              const Text("Native Ad:"),
              Container(
                height: 120,
                child: SimpleAdsManager.instance.native(
                  nativeTemplateStyle: NativeTemplateStyle(
                    templateType: TemplateType.medium,
                    mainBackgroundColor: Colors.white,
                    cornerRadius: 10.0,
                    callToActionTextStyle: NativeTemplateTextStyle(
                      textColor: Colors.white,
                      backgroundColor: Colors.blue,
                      size: 16.0,
                      style: NativeTemplateFontStyle.bold,
                    ),
                    primaryTextStyle: NativeTemplateTextStyle(
                      textColor: Colors.black,
                      size: 16.0,
                    ),
                    secondaryTextStyle: NativeTemplateTextStyle(
                      textColor: Colors.grey,
                      size: 14.0,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Show Interstitial Ad
                  SimpleAdsManager.instance.interstitial(
                    context: context,
                    onDismiss: (adShown) {
                      debugPrint("Interstitial Ad Dismissed: $adShown");
                    },
                  );
                },
                child: const Text("Show Interstitial Ad"),
              ),

              ElevatedButton(
                onPressed: () {
                  // Show Rewarded Ad
                  SimpleAdsManager.instance.rewarded(
                    context: context,
                    onRewarded: (reward, adShown) {
                      debugPrint(
                          "Rewarded Ad Completed: $adShown, Reward: ${reward?.amount ?? 0}");
                    },
                  );
                },
                child: const Text("Show Rewarded Ad"),
              ),

              ElevatedButton(
                onPressed: () {
                  // Show Rewarded Interstitial Ad
                  SimpleAdsManager.instance.rewardedInterstitial(
                    context: context,
                    onRewarded: (reward, adShown) {
                      debugPrint(
                          "Rewarded Interstitial Completed: $adShown, Reward: ${reward?.amount ?? 0}");
                    },
                  );
                },
                child: const Text("Show Rewarded Interstitial Ad"),
              ),

              ElevatedButton(
                onPressed: () {
                  // Show App Open Ad manually
                  SimpleAdsManager.instance.appOpen(
                    context: context,
                    onDismiss: (adShown) {
                      debugPrint("App Open Ad Dismissed: $adShown");
                    },
                  );
                },
                child: const Text("Show App Open Ad"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
