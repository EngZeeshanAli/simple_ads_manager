import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../models/AdConfig.dart';

class AdMobRewarded {
  static RewardedAd? _rewardedAd;

  static void loadRewardedAd() {
    RewardedAd.load(
        adUnitId: AdConfig.instance.ads.rewardedVideo,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {},
        ));
  }

  static void show(Function(RewardItem? reward) onRewarded) {
    if (_rewardedAd != null) {
      _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadRewardedAd();
          _rewardedAd = null;
        },
      );

      _rewardedAd?.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        onRewarded(reward);
      });
    } else {
      loadRewardedAd();
      onRewarded(null);
    }
  }
}
