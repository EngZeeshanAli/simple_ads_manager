import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/src/ads/banner.dart';
import 'package:simple_ads_manager/src/ads/interstitial.dart';
import 'package:simple_ads_manager/src/models/AdConfig.dart';

import '../simple_ads_manager.dart';
import 'ads/app_open.dart';
import 'ads/rewarded.dart';

class SimpleAdsManager {
  SimpleAdsManager._privateConstructor();

  static final SimpleAdsManager _instance =
      SimpleAdsManager._privateConstructor();

  static SimpleAdsManager get instance => _instance;

  Future<void> init(
      {bool? appOpen = false,
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

  Future<void> setAdUnits(String jsonAssetName) async {
    AdConfig.setAdUnits(jsonAssetName);
  }

  Widget showBanner() {
    return AdMobBanner(bannerAdUnit: AdConfig.instance.ads.banner);
  }

  void showInterstitialAd(Function() onDismiss) {
    AdmobInterstitial.showAd(onDismiss);
  }

  void showRewardedAd(Function(RewardItem? reward) onRewarded) {
    AdMobRewarded.show(onRewarded);
  }

  void showAppOpenAd() {
    AdmobAppOpen.show();
  }

  void appOpenAdCallback(AdmobAppOpenCallBacks callbacks) {
    AdmobAppOpen.callbacks = callbacks;
  }

  void enableAutoAppOpenAdFeature() {
    AppLifecycleReactorForAppOpen().listenToAppStateChanges();
  }
}
