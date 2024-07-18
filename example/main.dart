import 'package:flutter/material.dart';
import 'package:simple_ads_manager/simple_ads_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SimpleAdsManager.instance.setAdUnits("ads.json");
  await SimpleAdsManager.instance.init(
      appOpen: true, interstitial: true, rewarded: true);
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
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            SimpleAdsManager.instance.showBanner(),
            ElevatedButton(
                onPressed: () {
                  SimpleAdsManager.instance.showInterstitialAd(context, () {
                    // after innterstitial ad is dismissed or ad is not available
                  });
                },
                child: Text("Show Interstitial")),
            ElevatedButton(
                onPressed: () {
                  SimpleAdsManager.instance.showAppOpenAd(context, () {
                    // after ad is dismissed or ad is not available
                  });
                },
                child: Text("Show App Open")),
            ElevatedButton(
                onPressed: () {
                  SimpleAdsManager.instance.showRewardedAd(context, (reward) {
                    // after user has watched the ad
                    // if reward is null user has not watched the ad or ad is not available
                  });
                },
                child: Text("Show Rewarded")),
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
