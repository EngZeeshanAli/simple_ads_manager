import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:simple_ads_manager/src/ads/app_open.dart';
import 'package:simple_ads_manager/src/ads/banner.dart';
import 'package:simple_ads_manager/src/ads/interstitial.dart';
import 'package:simple_ads_manager/src/ads/interstitial_rewarded.dart';
import 'package:simple_ads_manager/src/ads/native.dart';
import 'package:simple_ads_manager/src/ads/rewarded.dart';
import 'package:simple_ads_manager/src/models/ad_type.dart';

class SimpleAdsManager {
  SimpleAdsManager._private();

  static final SimpleAdsManager _instance = SimpleAdsManager._private();

  static SimpleAdsManager get instance => _instance;

  /// Force test ads even outside debug mode.
  static bool alwaysTestADs = false;

  /// Initialize Google Mobile Ads SDK.
  Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  // ---------------------------------------------------------------------------
  // Banner Ads
  // ---------------------------------------------------------------------------

  /// Returns a banner ad widget.
  Widget banner({
    required String adUnitId,
    AdSize? adSize,
    Widget? loadingWidget,
    Widget? errorWidget,
    VoidCallback? onLoaded,
    Function(String error)? onFailed,
    Function(double revenue)? onRevenue,
  }) {
    return AdMobBanner(
      adUnitId: adUnitId,
      adSize: adSize,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
      onLoaded: onLoaded,
      onFailed: onFailed,
      onRevenue: onRevenue,
    );
  }

  // ---------------------------------------------------------------------------
  // Native Ads
  // ---------------------------------------------------------------------------

  /// Returns a native ad widget.
  Widget nativeAd({
    required String adUnitId,
    NativeTemplateStyle? nativeTemplateStyle,
    String? factory,
    double? height,
    BoxConstraints? constraints,
    Widget? loadingWidget,
    Widget? errorWidget,
    VoidCallback? onLoaded,
    Function(String error)? onFailed,
    Function(double revenue)? onRevenue,
  }) {
    return AdMobNative(
      adUnitId: adUnitId,
      nativeTemplateStyle: nativeTemplateStyle,
      factory: factory,
      height: height,
      constraints: constraints,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
      onLoaded: onLoaded,
      onFailed: onFailed,
      onRevenue: onRevenue,
    );
  }

  // ---------------------------------------------------------------------------
  // App Open Ads
  // ---------------------------------------------------------------------------

  /// Sets cooldown duration for app open ads.
  void setAppOpenCooldown(int seconds) {
    AdmobAppOpen.cooldown = Duration(seconds: seconds);
  }

  /// Loads and immediately shows an app open ad.
  void loadAndShowAppOpen({
    required String adUnitId,
    required BuildContext context,
    Function()? onShown,
    Function()? onDismissed,
    Function(String error)? onFailed,
    Function(double revenue)? onRevenue,
  }) {
    AdmobAppOpen.loadAndShow(
      adUnitId: adUnitId,
      context: context,
      onShown: onShown,
      onDismissed: onDismissed,
      onFailed: onFailed,
      onRevenue: onRevenue,
    );
  }

  /// Automatically shows app open ad when app returns to foreground.
  void showAppStateAppOpen({
    required String adUnitId,
    required BuildContext context,
    Function()? onShown,
    Function()? onDismissed,
    Function(String error)? onFailed,
    Function(double revenue)? onRevenue,
  }) {
    AppLifecycleReactorForAppOpen().listenToAppStateChanges(
      adUnitId: adUnitId,
      context: context,
      onShown: onShown,
      onDismissed: onDismissed,
      onFailed: onFailed,
      onRevenue: onRevenue,
    );
  }

  // ---------------------------------------------------------------------------
  // Interstitial Ads
  // ---------------------------------------------------------------------------

  /// Loads and immediately shows an interstitial ad.
  void loadAndShowInterstitial({
    required String adUnitId,
    required BuildContext context,
    Function()? onShown,
    Function()? onDismissed,
    Function(String error)? onFailed,
    Function(double revenue)? onRevenue,
  }) {
    AdmobInterstitial.loadAndShow(
      adUnitId: adUnitId,
      context: context,
      onShown: onShown,
      onDismissed: onDismissed,
      onFailed: onFailed,
      onRevenue: onRevenue,
    );
  }

  /// Preloads an interstitial ad for later use.
  void preloadInterstitial({
    required String adUnitId,
  }) {
    AdmobInterstitial.preload(adUnitId);
  }

  /// Shows a previously preloaded interstitial ad.
  void showPreloadedInterstitial({
    required BuildContext context,
    required String adUnitId,
    required Function(bool shown) onDismiss,
    Function(double revenue)? onRevenue,
  }) {
    AdmobInterstitial.showPreloaded(
      context: context,
      adUnitId: adUnitId,
      onDismiss: onDismiss,
      onRevenue: onRevenue,
    );
  }

  /// Returns true if a preloaded interstitial ad is ready.
  bool get isInterstitialReady => AdmobInterstitial.isReady;

  // ---------------------------------------------------------------------------
  // Rewarded Ads
  // ---------------------------------------------------------------------------

  /// Loads and immediately shows a rewarded ad.
  void loadAndShowRewarded({
    required String adUnitId,
    required BuildContext context,
    Function()? onShown,
    Function(RewardItem? reward, bool rewardEarned)? onCompleted,
    Function(String error)? onFailed,
    Function(double revenue)? onRevenue,
  }) {
    AdMobRewarded.loadAndShow(
      adUnitId: adUnitId,
      context: context,
      onShown: onShown,
      onCompleted: onCompleted,
      onFailed: onFailed,
      onRevenue: onRevenue,
    );
  }

  // ---------------------------------------------------------------------------
  // Rewarded Interstitial Ads
  // ---------------------------------------------------------------------------

  /// Loads and immediately shows a rewarded interstitial ad.
  void loadAndShowRewardedInterstitial({
    required String adUnitId,
    required BuildContext context,
    Function()? onShown,
    Function(RewardItem? reward, bool rewardEarned)? onDismissed,
    Function(String error)? onFailed,
    Function(double revenue)? onRevenue,
  }) {
    AdmobRewardedInterstitial.loadAndShow(
      adUnitId: adUnitId,
      context: context,
      onShown: onShown,
      onDismissed: onDismissed,
      onFailed: onFailed,
      onRevenue: onRevenue,
    );
  }

  /// Preloads a rewarded interstitial ad.
  void preloadRewardedInterstitial({
    required String adUnitId,
  }) {
    AdmobRewardedInterstitial.preload(adUnitId);
  }

  /// Shows a previously preloaded rewarded interstitial ad.
  void showPreloadedRewardedInterstitial({
    required BuildContext context,
    required String adUnitId,
    Function()? onShown,
    Function(RewardItem? reward, bool rewardEarned)? onDismissed,
    Function(String error)? onFailed,
    Function(double revenue)? onRevenue,
  }) {
    AdmobRewardedInterstitial.showPreloaded(
      context: context,
      adUnitId: adUnitId,
      onShown: onShown,
      onDismissed: onDismissed,
      onFailed: onFailed,
      onRevenue: onRevenue,
    );
  }

  // ---------------------------------------------------------------------------
  // Generic Availability
  // ---------------------------------------------------------------------------

  /// Checks whether a preloaded ad is available for the given type.
  ///
  /// Note:
  /// - Banner and Native are widget-based, so this check is only meaningful for
  ///   full-screen ad formats.
  bool isAvailable(String adType) {
    switch (adType) {
      case AdType.interstitial:
        return AdmobInterstitial.isReady;
      // case AdType.rewarded:
      //   return AdMobRewarded.isReady;
      case AdType.rewardedInterstitial:
        return AdmobRewardedInterstitial.isReady;
      default:
        return false;
    }
  }
}
