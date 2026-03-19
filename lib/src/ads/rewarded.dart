import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/src/models/ad_config.dart';
import 'package:simple_ads_manager/src/utils/simple_overlay.dart';

class AdMobRewarded {
  static bool _isShowing = false;

  static void loadAndShow({
    required String adUnitId,
    required BuildContext context,
    Function()? onShown,
    Function(RewardItem? reward, bool rewardEarned)? onCompleted,
    Function(String error)? onFailed,
    Function(double revenue)? onRevenue,
  }) {
    if (_isShowing) return;

    RewardedAd.load(
      adUnitId: AdConfig.getRewarded(adUnitId),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Rewarded Ad loaded');
          RewardItem? rewardItem;
          bool rewardEarned = false;

          ad.onPaidEvent = (
            Ad ad,
            double valueMicros,
            PrecisionType precision,
            String currencyCode,
          ) {
            final revenue = valueMicros / 1e6;
            debugPrint('💰 Rewarded revenue: $revenue $currencyCode');
            onRevenue?.call(revenue);
          };

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              _isShowing = true;
              onShown?.call();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _isShowing = false;
              ad.dispose();
              SimpleOverlay.dismiss();
              onFailed?.call(error.message);
            },
            onAdDismissedFullScreenContent: (ad) {
              _isShowing = false;
              ad.dispose();
              SimpleOverlay.dismiss();
              onCompleted?.call(rewardItem, rewardEarned);
            },
          );

          SimpleOverlay.show(context);

          ad.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              rewardItem = reward;
              rewardEarned = true;
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Rewarded load failed: ${error.message}');
          onFailed?.call(error.message);
        },
      ),
    );
  }
}
