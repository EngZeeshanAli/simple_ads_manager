import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/simple_ads_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SimpleAdsManager.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String bannerAdUnitId = 'ca-app-pub-xxxxxxxxxxxxxxxx/banner-id';
  final String nativeAdUnitId = 'ca-app-pub-xxxxxxxxxxxxxxxx/native-id';
  final String interstitialAdUnitId =
      'ca-app-pub-xxxxxxxxxxxxxxxx/interstitial-id';
  final String rewardedAdUnitId = 'ca-app-pub-xxxxxxxxxxxxxxxx/rewarded-id';
  final String rewardedInterstitialAdUnitId =
      'ca-app-pub-xxxxxxxxxxxxxxxx/rewarded-interstitial-id';
  final String appOpenAdUnitId = 'ca-app-pub-xxxxxxxxxxxxxxxx/app-open-id';

  @override
  void initState() {
    super.initState();

    // Preload fullscreen ads if you want better UX
    SimpleAdsManager.instance.preloadInterstitial(
      adUnitId: interstitialAdUnitId,
    );

    SimpleAdsManager.instance.preloadRewardedInterstitial(
      adUnitId: rewardedInterstitialAdUnitId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Ads Demo"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 16),

              const Text("Banner Ad:"),
              const SizedBox(height: 8),
              SimpleAdsManager.instance.banner(
                adUnitId: bannerAdUnitId,
                onLoaded: () {
                  debugPrint("Banner loaded");
                },
                onFailed: (error) {
                  debugPrint("Banner failed: $error");
                },
                onRevenue: (revenue) {
                  debugPrint("Banner revenue: $revenue");
                },
              ),

              const SizedBox(height: 24),

              const Text("Native Ad:"),
              const SizedBox(height: 8),
              SimpleAdsManager.instance.nativeAd(
                adUnitId: nativeAdUnitId,
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
                onLoaded: () {
                  debugPrint("Native loaded");
                },
                onFailed: (error) {
                  debugPrint("Native failed: $error");
                },
                onRevenue: (revenue) {
                  debugPrint("Native revenue: $revenue");
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  SimpleAdsManager.instance.loadAndShowInterstitial(
                    adUnitId: interstitialAdUnitId,
                    context: context,
                    onShown: () {
                      debugPrint("Interstitial shown");
                    },
                    onDismissed: () {
                      debugPrint("Interstitial dismissed");
                    },
                    onFailed: (error) {
                      debugPrint("Interstitial failed: $error");
                    },
                    onRevenue: (revenue) {
                      debugPrint("Interstitial revenue: $revenue");
                    },
                  );
                },
                child: const Text("Show Interstitial Ad"),
              ),

              ElevatedButton(
                onPressed: () {
                  SimpleAdsManager.instance.showPreloadedInterstitial(
                    context: context,
                    adUnitId: interstitialAdUnitId,
                    onDismiss: (shown) {
                      debugPrint("Preloaded Interstitial dismissed: $shown");
                    },
                    onRevenue: (revenue) {
                      debugPrint("Preloaded Interstitial revenue: $revenue");
                    },
                  );
                },
                child: const Text("Show Preloaded Interstitial"),
              ),

              ElevatedButton(
                onPressed: () {
                  SimpleAdsManager.instance.loadAndShowRewarded(
                    adUnitId: rewardedAdUnitId,
                    context: context,
                    onShown: () {
                      debugPrint("Rewarded shown");
                    },
                    onCompleted: (reward, rewardEarned) {
                      debugPrint(
                        "Rewarded completed: earned=$rewardEarned, amount=${reward?.amount ?? 0}",
                      );
                    },
                    onFailed: (error) {
                      debugPrint("Rewarded failed: $error");
                    },
                    onRevenue: (revenue) {
                      debugPrint("Rewarded revenue: $revenue");
                    },
                  );
                },
                child: const Text("Show Rewarded Ad"),
              ),

              ElevatedButton(
                onPressed: () {
                  SimpleAdsManager.instance.loadAndShowRewardedInterstitial(
                    adUnitId: rewardedInterstitialAdUnitId,
                    context: context,
                    onShown: () {
                      debugPrint("Rewarded Interstitial shown");
                    },
                    onDismissed: (reward, rewardEarned) {
                      debugPrint(
                        "Rewarded Interstitial completed: earned=$rewardEarned, amount=${reward?.amount ?? 0}",
                      );
                    },
                    onFailed: (error) {
                      debugPrint("Rewarded Interstitial failed: $error");
                    },
                    onRevenue: (revenue) {
                      debugPrint("Rewarded Interstitial revenue: $revenue");
                    },
                  );
                },
                child: const Text("Show Rewarded Interstitial Ad"),
              ),

              ElevatedButton(
                onPressed: () {
                  SimpleAdsManager.instance.loadAndShowAppOpen(
                    adUnitId: appOpenAdUnitId,
                    context: context,
                    onShown: () {
                      debugPrint("App Open Ad Shown");
                    },
                    onDismissed: () {
                      debugPrint("App Open Ad Dismissed");
                    },
                    onFailed: (error) {
                      debugPrint("App Open Ad Failed: $error");
                    },
                    onRevenue: (revenue) {
                      debugPrint("App Open Ad Revenue: $revenue");
                    },
                  );
                },
                child: const Text("Show App Open Ad"),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}