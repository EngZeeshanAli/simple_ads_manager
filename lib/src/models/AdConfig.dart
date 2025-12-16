import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:simple_ads_manager/simple_ads_manager.dart';
import 'package:simple_ads_manager/src/models/ad_type.dart';
import 'package:simple_ads_manager/src/models/test_ad_helper.dart';
import 'package:flutter/foundation.dart';

class AdConfig {
  // Android Ad Unit IDs
  static String? bannerAndroid;
  static String? interstitialAndroid;
  static String? rewardedAndroid;
  static String? rewardedInterstitialAndroid;
  static String? nativeAndroid;
  static String? appOpenAndroid;

  // iOS Ad Unit IDs
  static String? bannerIOS;
  static String? interstitialIOS;
  static String? rewardedIOS;
  static String? rewardedInterstitialIOS;
  static String? nativeIOS;
  static String? appOpenIOS;

  //ads enabled flags
  static bool enableBanner = false;
  static bool enableInterstitial = false;
  static bool enableRewarded = false;
  static bool enableRewardedInterstitial = false;
  static bool enableNative = false;
  static bool enableAppOpen = false;

  static String getBanner() =>
      _getAdUnit(bannerAndroid, bannerIOS, AdType.banner);

  static String getInterstitial() =>
      _getAdUnit(interstitialAndroid, interstitialIOS, AdType.interstitial);

  static String getRewarded() =>
      _getAdUnit(rewardedAndroid, rewardedIOS, AdType.rewarded);

  static String getRewardedInterstitial() => _getAdUnit(
      rewardedInterstitialAndroid,
      rewardedInterstitialIOS,
      AdType.rewardedInterstitial);

  static String getNative() =>
      _getAdUnit(nativeAndroid, nativeIOS, AdType.native);

  static String getAppOpen() =>
      _getAdUnit(appOpenAndroid, appOpenIOS, AdType.appOpen);

  static String _getAdUnit(String? android, String? ios, String type) {
    if (kDebugMode || SimpleAdsManager.alwaysTestADs)
      return TestAdUnits.getAdTestUnit(type);
    if (android == null && ios == null) {
      throw UnsupportedError('Ad unit id is not provided for $type');
    }
    return Platform.isAndroid ? (android ?? '') : (ios ?? '');
  }

  static setAdUnits({
    String? bannerAndroidId,
    String? interstitialAndroidId,
    String? rewardedAndroidId,
    String? rewardedInterstitialAndroidId,
    String? nativeAndroidId,
    String? appOpenAndroidId,
    String? bannerIOSId,
    String? interstitialIOSId,
    String? rewardedIOSId,
    String? rewardedInterstitialIOSId,
    String? nativeIOSId,
    String? appOpenIOSId,
  }) {
    bannerAndroid = bannerAndroidId;
    interstitialAndroid = interstitialAndroidId;
    rewardedAndroid = rewardedAndroidId;
    rewardedInterstitialAndroid = rewardedInterstitialAndroidId;
    nativeAndroid = nativeAndroidId;
    appOpenAndroid = appOpenAndroidId;
    bannerIOS = bannerIOSId;
    interstitialIOS = interstitialIOSId;
    rewardedIOS = rewardedIOSId;
    rewardedInterstitialIOS = rewardedInterstitialIOSId;
    nativeIOS = nativeIOSId;
    appOpenIOS = appOpenIOSId;
  }
}
