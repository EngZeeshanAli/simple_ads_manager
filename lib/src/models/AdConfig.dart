import 'package:simple_ads_manager/simple_ads_manager.dart';
import 'package:simple_ads_manager/src/models/test_ad_helper.dart';

class AdConfig {
  static String getInterstitial(String adUnitId) {
    return SimpleAdsManager.alwaysTestADs
        ? TestAdUnits.getAdTestUnit(AdType.interstitial)
        : _validate(adUnitId, AdType.interstitial);
  }

  static String getRewardedInterstitial(String adUnitId) {
    return SimpleAdsManager.alwaysTestADs
        ? TestAdUnits.getAdTestUnit(AdType.rewardedInterstitial)
        : _validate(adUnitId, AdType.rewardedInterstitial);
  }

  static String getAppOpen(String adUnitId) {
    return SimpleAdsManager.alwaysTestADs
        ? TestAdUnits.getAdTestUnit(AdType.appOpen)
        : _validate(adUnitId, AdType.appOpen);
  }

  static String getBanner(String adUnitId) {
    return SimpleAdsManager.alwaysTestADs
        ? TestAdUnits.getAdTestUnit(AdType.banner)
        : _validate(adUnitId, AdType.banner);
  }

  static String getNative(String adUnitId) {
    return SimpleAdsManager.alwaysTestADs
        ? TestAdUnits.getAdTestUnit(AdType.native)
        : _validate(adUnitId, AdType.native);
  }

  static String getRewarded(String adUnitId) {
    return SimpleAdsManager.alwaysTestADs
        ? TestAdUnits.getAdTestUnit(AdType.rewarded)
        : _validate(adUnitId, AdType.rewarded);
  }



  static String _validate(String adUnitId, String type) {
    if (adUnitId.isEmpty) {
      throw UnsupportedError('Ad Unit ID missing for $type');
    }
    return adUnitId;
  }
}
