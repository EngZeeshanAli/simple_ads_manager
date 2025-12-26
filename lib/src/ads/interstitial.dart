import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/src/utils/simple_overlay.dart';
import '../models/AdConfig.dart';

class AdmobInterstitial {
  static bool _isShowing = false;
  static InterstitialAd? _interstitialAd;
  static bool _isLoading = false;

  static bool get isReady => _interstitialAd != null;


  static void loadAndShow({
    required String adUnitId,
    required BuildContext context,
    Function()? onShown,
    Function()? onDismissed,
    Function(String error)? onFailed,
    Function(double revenue)? onRevenue,
  }) {
    if (_isShowing) return;

    InterstitialAd.load(
      adUnitId: AdConfig.getInterstitial(adUnitId),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Interstitial Ad loaded');

          ad.onPaidEvent = (Ad ad,
              double valueMicros,
              PrecisionType precision,
              String currencyCode,) {
            final revenue = valueMicros / 1000000;
            debugPrint('💰 Interstitial revenue: $revenue $currencyCode');
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
              onDismissed?.call();
            },
            onAdImpression: (ad) {
              debugPrint('✅ Interstitial ad impression occurred.');
            },
          );

          SimpleOverlay.show(context);
          ad.show();
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Failed to load interstitial ad: ${error.message}');
          onFailed?.call(error.message);
        },
      ),
    );
  }


  /// Preload interstitial
  static void preload(String adUnitId) {
    if (_interstitialAd != null || _isLoading) return;

    _isLoading = true;

    InterstitialAd.load(
      adUnitId: AdConfig.getInterstitial(adUnitId),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd?.dispose();
          _interstitialAd = ad;
          _isLoading = false;
          debugPrint('✅ Interstitial preloaded');

        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          _interstitialAd = null;
          debugPrint('❌ Interstitial preload failed: ${error.message}');
        },
      ),
    );
  }

  /// Show if ready
  static void showPreloaded({
    required BuildContext context,
    required String adUnitId,
    required Function(bool shown) onDismiss,
    Function(double revenue)? onRevenue,
  }) {
    if (_interstitialAd == null || _isShowing) {
      onDismiss(false);
      preload(adUnitId); // try preload again
      return;
    }

    final ad = _interstitialAd!;
    _interstitialAd = null;

    ad.onPaidEvent = (Ad ad,
        double valueMicros,
        PrecisionType precision,
        String currencyCode,) {
      final revenue = valueMicros / 1e6;
      onRevenue?.call(revenue);
    };

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowing = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowing = false;
        ad.dispose();
        SimpleOverlay.dismiss();
        onDismiss(true);
        preload(adUnitId); // preload next
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowing = false;
        ad.dispose();
        SimpleOverlay.dismiss();
        onDismiss(false);
        preload(adUnitId); // preload next
      },
    );

    SimpleOverlay.show(context);
    ad.show();
  }

}
