import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../simple_ads_manager.dart';
import '../models/AdConfig.dart';
import 'blank_screen.dart';

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

  static void show(BuildContext context,Function(RewardItem? reward) onRewarded) {
    if (_rewardedAd != null) {
      RewardItem? rewardItem;

      _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          Navigator.of(context).pop();
          onRewarded(rewardItem);
          ad.dispose();
          loadRewardedAd();
          _rewardedAd = null;
        },
      );

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => BlankScreen()));
      _rewardedAd?.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        rewardItem = reward;
      });
    } else {
      loadRewardedAd();
      onRewarded(null);
    }
  }
}
