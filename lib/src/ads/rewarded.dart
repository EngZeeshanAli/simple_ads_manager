import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/src/utils/simple_overlay.dart';
import '../models/AdConfig.dart';

class AdMobRewarded {
  static RewardedAd? rewardedAd;

  static void loadRewardedAd() {
    if (!AdConfig.enableRewarded) {
      debugPrint('⚠️ Rewarded ads are disabled.');
      return;
    }

    debugPrint('⚠️ Loading Rewarded Ad...');
    RewardedAd.load(
      adUnitId: AdConfig.getRewarded(),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Rewarded Ad loaded');
          rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Failed to load Rewarded Ad: ${error.message}');
          rewardedAd = null;
        },
      ),
    );
  }

  static void show({
    required BuildContext context,
    Function(RewardItem? reward, bool adShown)? onRewarded,
    Function(double revenue)? onRevenue,
  }) {
    if (rewardedAd != null) {
      RewardItem? rewardItem;

      rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          SimpleOverlay.dismiss();
          ad.dispose();
          rewardedAd = null;
          debugPrint('⚠️ Rewarded Ad dismissed');
          onRewarded?.call(rewardItem, true);
          loadRewardedAd(); // reload for next time
        },
        onAdImpression: (ad) {
          debugPrint('✅ Rewarded ad impression occurred.');
        },
      );

      rewardedAd?.onPaidEvent = (ad, valueMicros, precision, currencyCode) {
        double revenue = valueMicros / 1e6;
        debugPrint('💰 Rewarded Ad revenue: $revenue $currencyCode');
        onRevenue?.call(revenue);
      };

      SimpleOverlay.show(context);
      rewardedAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          rewardItem = reward;
        },
      );

    } else {
      debugPrint('⚠️ Rewarded Ad not loaded yet, loading now.');
      loadRewardedAd();
      onRewarded?.call(null, false);
    }
  }
}
