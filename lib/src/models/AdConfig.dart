import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:simple_ads_manager/simple_ads_manager.dart';
import 'package:simple_ads_manager/src/models/test_ad_helper.dart';
import 'package:flutter/foundation.dart';

class AdConfig {
  final _AdsModel ads;

// Private constructor
  AdConfig._({required this.ads});

  // Singleton instance
  static AdConfig? _instance;

  static AdConfig get instance {
    return _instance ?? AdConfig.fromJson({});
  }


  static Future<void> setAdUnits(String jsonAssetName) async {
    final String response =
        await rootBundle.loadString('assets/$jsonAssetName');
    final data = await json.decode(response);
    if (Platform.isIOS) {
      _instance = AdConfig.fromJson(data['ios']);
    } else if (Platform.isAndroid) {
      _instance = AdConfig.fromJson(data['android']);
    }
  }

  factory AdConfig.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty)
      throw UnsupportedError(
          'No json file found. Add json file in assets folder');
    _instance ??= AdConfig._(ads: _AdsModel.fromJson(json));
    return _instance!;
  }
}

class _AdsModel {
  late final String _banner;
  late final String _interstitial;
  late final String _rewardedVideo;
  late final String _interstitialVideo;
  late final String _appOpen;

  _AdsModel(
    this._banner,
    this._interstitial,
    this._rewardedVideo,
    this._interstitialVideo,
    this._appOpen,
  );

  factory _AdsModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      throw UnsupportedError('Ad config is empty');
    }

    return _AdsModel(
      json['banner'] ?? "",
      json['interstitial'] ?? "",
      json['rewarded_video'] ?? "",
      json['interstitial_video'] ?? "",
      json['app_open'] ?? "",
    );
  }

  String get banner {
    if (kDebugMode || SimpleAdsManager.alwaysTestADs ==true) {
      return TestAdUnits.bannerAdUnitId;
    } else {
      if (_banner.isEmpty) {
        throw UnsupportedError('Banner ad unit id is empty');
      }
      return _banner;
    }
  }

  String get interstitial {
    if (kDebugMode|| SimpleAdsManager.alwaysTestADs ==true) {
      return TestAdUnits.interstitialAdUnitId;
    } else {
      if (_interstitial.isEmpty) {
        throw UnsupportedError('Interstitial ad unit id is empty');
      }
      return _interstitial;
    }
  }

  String get rewardedVideo {
    if (kDebugMode|| SimpleAdsManager.alwaysTestADs ==true) {
      return TestAdUnits.rewardedAdUnitId;
    } else {
      if (_rewardedVideo.isEmpty) {
        throw UnsupportedError('Rewarded video ad unit id is empty');
      }
      return _rewardedVideo;
    }
  }

  String get interStitialVideo {
    if (kDebugMode|| SimpleAdsManager.alwaysTestADs ==true) {
      return TestAdUnits.rewardedAdUnitId;
    } else {
      if (_interstitialVideo.isEmpty) {
        throw UnsupportedError('Interstitial video ad unit id is empty');
      }
      return _interstitialVideo;
    }
  }

  String get appOpen {
    if (kDebugMode|| SimpleAdsManager.alwaysTestADs ==true) {
      return TestAdUnits.appOpenAdUnitId;
    } else {
      if (_appOpen.isEmpty) {
        throw UnsupportedError('App open ad unit id is empty');
      }
      return _appOpen;
    }
  }
}
