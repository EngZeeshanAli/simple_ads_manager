import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/src/ads/banner.dart';
import 'package:simple_ads_manager/src/ads/interstitial.dart';
import 'package:simple_ads_manager/src/models/AdConfig.dart';
import 'ads/app_open.dart';
import 'ads/rewarded.dart';

class SimpleAdsManager {
  SimpleAdsManager._privateConstructor();

  static bool alwaysTestADs = false;

  static bool bannerEnabled = true;

  static final SimpleAdsManager _instance =
  SimpleAdsManager._privateConstructor();

  static SimpleAdsManager get instance => _instance;

  Future<void> init({bool? appOpen = false,
    bool interstitial = false,
    bool rewarded = false}) async {
    await MobileAds.instance.initialize();
    if (appOpen!) {
      AdmobAppOpen.loadAppOpen();
    }
    if (interstitial) {
      AdmobInterstitial.loadInterstitialAd();
    }
    if (rewarded) {
      AdMobRewarded.loadRewardedAd();
    }
  }

  Future<void> setNavigatorState(dynamic navigatorState) async {
    navigatorState = navigatorState;
  }

  Future<void> setAlwaysTestAds() async {
    SimpleAdsManager.alwaysTestADs = true;
  }

  Future<void> setAdUnits(String jsonAssetName) async {
    AdConfig.setAdUnits(jsonAssetName);
  }

  Widget showBanner({Function()? onLoaded }) {
    return AdMobBanner(
      bannerAdUnit: AdConfig.instance.ads.banner, onLoaded: onLoaded,);
  }

  void showInterstitialAd(BuildContext context, Function() onDismiss) {
    AdmobInterstitial.showAd(context, onDismiss);
  }

  void showRewardedAd(BuildContext context,
      Function(RewardItem? reward) onRewarded) {
    AdMobRewarded.show(context, onRewarded);
  }

  void showAppOpenAd(BuildContext context, Function() onDismiss) {
    AdmobAppOpen.show(context, onDismiss);
  }

  void enableAutoAppOpenAdFeature(BuildContext context) {
    AppLifecycleReactorForAppOpen().listenToAppStateChanges(context);
  }
}
