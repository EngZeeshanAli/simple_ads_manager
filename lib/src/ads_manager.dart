import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/src/ads/banner.dart';
import 'package:simple_ads_manager/src/ads/interstitial.dart';
import 'package:simple_ads_manager/src/ads/interstitial_rewarded.dart';
import 'package:simple_ads_manager/src/ads/native.dart';
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

  Future<void> init({
    bool? appOpen = false,
    bool interstitial = false,
    bool rewarded = false,
    bool rewardedInterstitial = false,
  }) async {
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
    if (rewardedInterstitial) {
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

  Widget showBanner({Function()? onLoaded, Function(Ad, double, PrecisionType, String)? onPaid}) {
    return AdMobBanner(
      bannerAdUnit: AdConfig.instance.ads.banner,
      onLoaded: onLoaded,
      onPaid: onPaid,
    );
  }

  Widget showNativeAd(
      {required NativeTemplateStyle nativeTemplateStyle,
      Function()? onLoaded, Function(Ad, double, PrecisionType, String)? onPaid}) {
    return AdMobNative(
      bannerAdUnit: AdConfig.instance.ads.native,
      onLoaded: onLoaded,
      nativeTemplateStyle: nativeTemplateStyle,
      onPaid: onPaid,
    );
  }

  void showInterstitialAd(BuildContext context, Function() onDismiss, { Function(Ad, double, PrecisionType, String)? onPaid }) {
    AdmobInterstitial.showAd(context, onDismiss, onPaid: onPaid);
  }

  void showRewardedAd(
      BuildContext context, Function(RewardItem? reward) onRewarded, { Function(Ad, double, PrecisionType, String)? onPaid }) {
    AdMobRewarded.show(context, onRewarded, onPaid: onPaid);
  }

  void showInterstitialRewardedAd(
      BuildContext context, Function(RewardItem? reward) onRewarded, { Function(Ad, double, PrecisionType, String)? onPaid }) {
    AdmobRewardedInterstitial.showAd(context, onRewarded, onPaid: onPaid);
  }

  void showAppOpenAd(BuildContext context, Function() onDismiss, { Function(Ad, double, PrecisionType, String)? onPaid }) {
    AdmobAppOpen.show(context, onDismiss, onPaid: onPaid);
  }

  void enableAutoAppOpenAdFeature(BuildContext context) {
    AppLifecycleReactorForAppOpen().listenToAppStateChanges(context);
  }
}
