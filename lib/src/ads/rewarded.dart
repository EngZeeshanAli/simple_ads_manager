import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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

  static void show(BuildContext context,Function(RewardItem? reward) onRewarded, { Function(Ad, double, PrecisionType, String)? onPaid }) {
    if (_rewardedAd != null) {
      _rewardedAd?.onPaidEvent =
          (Ad ad, double valueMicros, PrecisionType precision, String currencyCode) {
        final revenue = valueMicros / 1000000.0;
        final revenueString = "$revenue $currencyCode";
        onPaid!.call(ad, valueMicros, precision, currencyCode);
        print('RewardedAd paid event: $revenueString');
      };

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
