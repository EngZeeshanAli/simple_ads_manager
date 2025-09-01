import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/simple_ads_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SimpleAdsManager.instance.setAdUnits("ads.json");
  await SimpleAdsManager.instance.init(
      appOpen: true,
      interstitial: true,
      rewarded: true,
      rewardedInterstitial: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SimpleAdsManager.instance.enableAutoAppOpenAdFeature(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    //when ever the app is resumed the app open ad will be shown
    SimpleAdsManager.instance.enableAutoAppOpenAdFeature(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            SimpleAdsManager.instance.showBanner(),
            Container(
              height: 90,
              child: SimpleAdsManager.instance.showNativeAd(
                  nativeTemplateStyle: NativeTemplateStyle(
                      // Required: Choose a template.
                      templateType: TemplateType.medium,

                      // Optional: Customize the ad's style.
                      mainBackgroundColor: Colors.white,
                      cornerRadius: 10.0,
                      callToActionTextStyle: NativeTemplateTextStyle(
                          textColor: Colors.black,
                          backgroundColor: Colors.red,
                          style: NativeTemplateFontStyle.monospace,
                          size: 16.0),
                      primaryTextStyle: NativeTemplateTextStyle(
                          textColor: Colors.red,
                          backgroundColor: Colors.cyan,
                          style: NativeTemplateFontStyle.italic,
                          size: 16.0),
                      secondaryTextStyle: NativeTemplateTextStyle(
                          textColor: Colors.green,
                          backgroundColor: Colors.black,
                          style: NativeTemplateFontStyle.bold,
                          size: 16.0),
                      tertiaryTextStyle: NativeTemplateTextStyle(
                          textColor: Colors.brown,
                          backgroundColor: Colors.amber,
                          style: NativeTemplateFontStyle.normal,
                          size: 16.0))),
            ),
            ElevatedButton(
                onPressed: () {
                  SimpleAdsManager.instance.showInterstitialAd(context, () {
                    // after innterstitial ad is dismissed or ad is not available
                  },
                      onPaid: (ad, valueMicros, precision, currencyCode) {
                    // when user has paid for the ad
                        final revenue = valueMicros / 1000000.0;
                        print("InterstitialAd paid event: $revenue $currencyCode");
                  }
                  );
                },
                child: Text("Show Interstitial")),
            ElevatedButton(
                onPressed: () {
                  SimpleAdsManager.instance.showAppOpenAd(context, () {
                    // after ad is dismissed or ad is not available
                  },
                  onPaid: (ad, valueMicros, precision, currencyCode) {
                    // when user has paid for the ad
                        final revenue = valueMicros / 1000000.0;
                        print("AppOpenAd paid event: $revenue $currencyCode");
                  }
                  );
                },
                child: Text("Show App Open")),
            ElevatedButton(
                onPressed: () {
                  SimpleAdsManager.instance.showRewardedAd(context, (reward) {
                    // after user has watched the ad
                    // if reward is null user has not watched the ad or ad is not available
                  },
                      onPaid: (ad, valueMicros, precision, currencyCode) {
                    // when user has paid for the ad
                        final revenue = valueMicros / 1000000.0;
                        print("RewardedAd paid event: $revenue $currencyCode");
                  }
                  );
                },
                child: Text("Show Rewarded")),
            ElevatedButton(
                onPressed: () {
                  SimpleAdsManager.instance.showInterstitialRewardedAd(context,
                      (reward) {
                    // after user has watched the ad
                    // if reward is null user has not watched the ad or ad is not available
                  },
                    onPaid: (ad, valueMicros, precision, currencyCode) {
                      // when user has paid for the ad
                        final revenue = valueMicros / 1000000.0;
                        print("RewardedInterstitialAd paid event: $revenue $currencyCode");
                    }
                  );
                },
                child: Text("Show Interstitial Rewarded")),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
