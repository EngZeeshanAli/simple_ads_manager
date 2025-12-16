import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/src/ads/banner.dart';
import 'package:simple_ads_manager/src/ads/interstitial.dart';
import 'package:simple_ads_manager/src/ads/native.dart';
import 'package:simple_ads_manager/src/models/AdConfig.dart';
import 'package:simple_ads_manager/src/models/ad_type.dart';
import 'ads/app_open.dart';
import 'ads/interstitial_rewarded.dart';
import 'ads/rewarded.dart';

class SimpleAdsManager {
  SimpleAdsManager._private();

  static final SimpleAdsManager _instance = SimpleAdsManager._private();

  static SimpleAdsManager get instance => _instance;
  static bool alwaysTestADs = false;

  /// Initialize all ad unit IDs for Android & iOS
  Future<void> initAdsManager({
    // Android
    String? bannerAndroid,
    String? interstitialAndroid,
    String? rewardedAndroid,
    String? rewardedInterstitialAndroid,
    String? nativeAndroid,
    String? appOpenAndroid,

    // iOS
    String? bannerIOS,
    String? interstitialIOS,
    String? rewardedIOS,
    String? rewardedInterstitialIOS,
    String? nativeIOS,
    String? appOpenIOS,
  }) async {
    await MobileAds.instance.initialize();
    AdConfig.setAdUnits(
      bannerAndroidId: bannerAndroid,
      interstitialAndroidId: interstitialAndroid,
      rewardedAndroidId: rewardedAndroid,
      rewardedInterstitialAndroidId: rewardedInterstitialAndroid,
      nativeAndroidId: nativeAndroid,
      appOpenAndroidId: appOpenAndroid,
      bannerIOSId: bannerIOS,
      interstitialIOSId: interstitialIOS,
      rewardedIOSId: rewardedIOS,
      rewardedInterstitialIOSId: rewardedInterstitialIOS,
      nativeIOSId: nativeIOS,
      appOpenIOSId: appOpenIOS,
    );
  }

  /// Enable or disable ads globally
  void enableAds({
    bool banner = false,
    bool native = false,
    bool appOpen = false,
    bool interstitial = false,
    bool rewarded = false,
    bool rewardedInterstitial = false,
  }) {
    AdConfig.enableBanner = banner;
    AdConfig.enableNative = native;
    AdConfig.enableAppOpen = appOpen;
    AdConfig.enableInterstitial = interstitial;
    AdConfig.enableRewarded = rewarded;
    AdConfig.enableRewardedInterstitial = rewardedInterstitial;

    interstitial ? AdmobInterstitial.loadInterstitialAd() : null;
    rewarded ? AdMobRewarded.loadRewardedAd() : null;
    appOpen ? AdmobAppOpen.loadAppOpen() : null;
    rewardedInterstitial
        ? AdmobRewardedInterstitial.loadRewardedInterstitialAd()
        : null;
  }

  /// Show a Banner Ad
  Widget banner({Function()? onLoaded, Function(double revenue)? onRevenue}) {
    return AdMobBanner(onLoaded: onLoaded);
  }

  /// Show a Native Ad
  Widget native({
    required NativeTemplateStyle nativeTemplateStyle,
    Function()? onLoaded,
    Function(double revenue)? onRevenue,
  }) {
    return AdMobNative(
      style: nativeTemplateStyle,
      onLoaded: onLoaded,
      onRevenue: onRevenue,
    );
  }

  /// Show an App Open Ad
  void appOpen({
    required BuildContext context,
    Function(bool adShown)? onDismiss,
    Function(double revenue)? onRevenue,
  }) {
    AdmobAppOpen.show(
      context: context,
      onDismiss: onDismiss,
      onRevenue: onRevenue,
    );
  }

  /// Enable automatic App Open Ads on app lifecycle changes
  void autoAppOpen({
    required BuildContext context,
    Function(bool adShown)? onDismiss,
    Function(double revenue)? onRevenue,
  }) {
    AppLifecycleReactorForAppOpen().listenToAppStateChanges(
      context: context,
      onDismiss: onDismiss,
      onRevenue: onRevenue,
    );
  }

  /// Show an Interstitial Ad
  void interstitial({
    required BuildContext context,
    required Function(bool adShown) onDismiss,
    Function(double revenue)? onRevenue,
  }) {
    AdmobInterstitial.showAd(
      context: context,
      onDismiss: onDismiss,
      onRevenue: onRevenue,
    );
  }

  /// Show a Rewarded Ad
  void rewarded({
    required BuildContext context,
    Function(RewardItem? reward, bool adShown)? onRewarded,
    Function(double revenue)? onRevenue,
  }) {
    AdMobRewarded.show(
      context: context,
      onRewarded: onRewarded,
      onRevenue: onRevenue,
    );
  }

  /// Show a Rewarded Interstitial Ad
  void rewardedInterstitial({
    required BuildContext context,
    Function(RewardItem? reward, bool adShown)? onRewarded,
    Function(double revenue)? onRevenue,
  }) {
    AdmobRewardedInterstitial.showAd(
      context: context,
      onRewarded: onRewarded,
      onRevenue: onRevenue,
    );
  }

  /// Check if a specific ad type is available
  bool isAvailable(String adType) {
    switch (adType) {
      case AdType.appOpen:
        return AdmobAppOpen.appOpenAd != null;
      case AdType.interstitial:
        return AdmobInterstitial.interstitialAd != null;
      case AdType.rewarded:
        return AdMobRewarded.rewardedAd != null;
      case AdType.rewardedInterstitial:
        return AdmobRewardedInterstitial.rewardedInterstitialAd != null;
      default:
        return false;
    }
  }
}
