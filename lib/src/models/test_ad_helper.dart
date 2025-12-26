import 'dart:io';

import 'ad_type.dart';

class TestAdUnits {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedInterstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5354046379";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/6978759866";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get appOpenAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/9257395921";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/5575463023";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/2247696110";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/3986624511";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String getAdTestUnit(String type) {
    switch (type) {
      case AdType.banner:
        return bannerAdUnitId;
      case AdType.interstitial:
        return interstitialAdUnitId;
      case AdType.rewarded:
        return rewardedAdUnitId;
      case AdType.rewardedInterstitial:
        return rewardedInterstitialAdUnitId;
      case AdType.appOpen:
        return appOpenAdUnitId;
      case AdType.native:
        return nativeAdUnitId;
      default:
        throw UnsupportedError("Unsupported ad unit type");
    }
  }
}
