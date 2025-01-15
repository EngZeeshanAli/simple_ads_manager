import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/AdConfig.dart';
import 'blank_screen.dart';

class AdmobRewardedInterstitial {
  static RewardedInterstitialAd? _rewardedInterstitialAd;
  static bool showingAd = false;

  static void loadRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
      adUnitId: AdConfig.instance.ads.interStitialVideo,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedInterstitialAd = ad;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an rewardedInterstitial ad: ${err.message}');
          _rewardedInterstitialAd = null;
        },
      ),
    );
  }

  static void showAd(
      BuildContext context, Function(RewardItem? reward) onRewarded) {
    if (_rewardedInterstitialAd != null) {
      RewardItem? rewardItem;

      _rewardedInterstitialAd?.fullScreenContentCallback =
          FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          Navigator.of(context).pop();
          ad.dispose();
          _rewardedInterstitialAd = null;
          onRewarded(rewardItem);
          loadRewardedInterstitialAd();
        },
      );

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => BlankScreen()));
      _rewardedInterstitialAd?.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        rewardItem = reward;
      });
    } else {
      AdmobRewardedInterstitial.loadRewardedInterstitialAd();
      onRewarded(null);
    }
  }
}
