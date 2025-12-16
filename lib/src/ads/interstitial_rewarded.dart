import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/src/utils/simple_overlay.dart';
import '../models/AdConfig.dart';

class AdmobRewardedInterstitial {
  static RewardedInterstitialAd? rewardedInterstitialAd;

  static void loadRewardedInterstitialAd() {
    if (!AdConfig.enableRewarded) {
      debugPrint('⚠️ RewardedInterstitial ads are disabled.');
      return;
    }
    RewardedInterstitialAd.load(
      adUnitId: AdConfig.getRewardedInterstitial(),
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ RewardedInterstitial Ad loaded');
          rewardedInterstitialAd = ad;
        },
        onAdFailedToLoad: (err) {
          debugPrint(
              '❌ Failed to load RewardedInterstitial Ad: ${err.message}');
          rewardedInterstitialAd = null;
        },
      ),
    );
  }

  static void showAd({
    required BuildContext context,
    Function(RewardItem? reward, bool adShown)? onRewarded,
    Function(double revenue)? onRevenue,
  }) {
    if (rewardedInterstitialAd != null) {
      RewardItem? rewardItem;

      rewardedInterstitialAd?.fullScreenContentCallback =
          FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          SimpleOverlay.dismiss();
          ad.dispose();
          rewardedInterstitialAd = null;
          debugPrint('⚠️ RewardedInterstitial Ad dismissed');
          onRewarded?.call(rewardItem, true);
          loadRewardedInterstitialAd(); // reload for next time
        },
        onAdImpression: (ad) {
          debugPrint('✅ RewardedInterstitial ad impression occurred.');
        },
      );

      rewardedInterstitialAd?.onPaidEvent =
          (ad, valueMicros, precision, currencyCode) {
        double revenue = valueMicros / 1e6;
        debugPrint('💰 RewardedInterstitial revenue: $revenue $currencyCode');
        onRevenue?.call(revenue);
      };

      SimpleOverlay.show(context);
      rewardedInterstitialAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          rewardItem = reward;
        },
      );
    } else {
      debugPrint('⚠️ RewardedInterstitial Ad not loaded yet, loading now.');
      loadRewardedInterstitialAd();
      onRewarded?.call(null, false);
    }
  }
}
