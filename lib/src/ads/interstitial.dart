import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/src/utils/simple_overlay.dart';
import '../models/AdConfig.dart';

class AdmobInterstitial {
  static InterstitialAd? interstitialAd;

  static void loadInterstitialAd() {
    if (!AdConfig.enableInterstitial) {
      debugPrint('⚠️ Interstitial ads are disabled.');
      return;
    }
    // load the interstitial ad
    InterstitialAd.load(
      adUnitId: AdConfig.getInterstitial(),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          debugPrint('✅ Interstitial Ad loaded');
        },
        onAdFailedToLoad: (err) {
          debugPrint('❌ Failed to load an interstitial ad: ${err.message}');
          interstitialAd = null;
        },
      ),
    );
  }

  static void showAd(
      {required BuildContext context,
      required Function(bool adShown) onDismiss,
      Function(double revenue)? onRevenue}) {
    if (interstitialAd != null) {
      interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          SimpleOverlay.dismiss();
          ad.dispose();
          interstitialAd = null;
          onDismiss.call(true);
          loadInterstitialAd();
        },
        onAdImpression: (ad) {
          debugPrint('✅ Interstitial ad impression occurred.');
        },
      );

      interstitialAd?.onPaidEvent = (Ad ad, double valueMicros,
          PrecisionType precision, String currencyCode) {
        double revenue =
            valueMicros / 1000000; // convert micros to currency units
        debugPrint('💰 App Open revenue: $revenue $currencyCode');
        onRevenue?.call(revenue);
      };

      SimpleOverlay.show(context);
      interstitialAd?.show();
    } else {
      AdmobInterstitial.loadInterstitialAd();
      onDismiss.call(false);
    }
  }
}

