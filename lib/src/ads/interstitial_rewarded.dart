import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/src/utils/simple_overlay.dart';
import '../models/AdConfig.dart';

class AdmobRewardedInterstitial {
  static bool _isShowing = false;
  static RewardedInterstitialAd? _rewardedInterstitialAd;
  static bool _isLoading = false;

  static bool get isReady => _rewardedInterstitialAd != null;

  static void loadAndShow({
    required String adUnitId,
    required BuildContext context,
    Function()? onShown,
    Function(RewardItem? reward, bool rewardEarned)? onDismissed,
    Function(String error)? onFailed,
    Function(double revenue)? onRevenue,
  }) {
    if (_isShowing) return;

    RewardedInterstitialAd.load(
      adUnitId: AdConfig.getRewardedInterstitial(adUnitId),
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ RewardedInterstitial loaded');

          RewardItem? rewardItem;
          bool rewardEarned = false;

          ad.onPaidEvent = (
            Ad ad,
            double valueMicros,
            PrecisionType precision,
            String currencyCode,
          ) {
            final revenue = valueMicros / 1e6;
            debugPrint(
                '💰 RewardedInterstitial revenue: $revenue $currencyCode');
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
              onDismissed?.call(rewardItem, rewardEarned);
            },
            onAdImpression: (ad) {
              debugPrint('✅ RewardedInterstitial impression occurred.');
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
          debugPrint('❌ RewardedInterstitial load failed: ${error.message}');
          onFailed?.call(error.message);
        },
      ),
    );
  }

  static void preload(String adUnitId) {
    if (_rewardedInterstitialAd != null || _isLoading) return;

    _isLoading = true;

    RewardedInterstitialAd.load(
      adUnitId: AdConfig.getRewardedInterstitial(adUnitId),
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedInterstitialAd?.dispose();
          _rewardedInterstitialAd = ad;
          _isLoading = false;
          debugPrint('✅ RewardedInterstitial preloaded');
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          _rewardedInterstitialAd = null;
          debugPrint('❌ RewardedInterstitial preload failed: ${error.message}');
        },
      ),
    );
  }

  static void showPreloaded({
    required BuildContext context,
    required String adUnitId,
    Function()? onShown,
    Function(RewardItem? reward, bool rewardEarned)? onDismissed,
    Function(String error)? onFailed,
    Function(double revenue)? onRevenue,
  }) {
    if (_rewardedInterstitialAd == null || _isShowing) {
      onFailed?.call('RewardedInterstitial not ready');
      preload(adUnitId);
      return;
    }

    final ad = _rewardedInterstitialAd!;
    _rewardedInterstitialAd = null;

    RewardItem? rewardItem;
    bool rewardEarned = false;

    ad.onPaidEvent = (
      Ad ad,
      double valueMicros,
      PrecisionType precision,
      String currencyCode,
    ) {
      final revenue = valueMicros / 1e6;
      onRevenue?.call(revenue);
    };

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowing = true;
        onShown?.call();
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowing = false;
        ad.dispose();
        SimpleOverlay.dismiss();
        onDismissed?.call(rewardItem, rewardEarned);
        preload(adUnitId);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowing = false;
        ad.dispose();
        SimpleOverlay.dismiss();
        onFailed?.call(error.message);
        preload(adUnitId);
      },
      onAdImpression: (ad) {
        debugPrint('✅ RewardedInterstitial impression occurred.');
      },
    );

    SimpleOverlay.show(context);

    ad.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        rewardItem = reward;
        rewardEarned = true;
      },
    );
  }
}
