import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/AdConfig.dart';
import 'blank_screen.dart';

class AdmobInterstitial {

  static InterstitialAd? _interstitialAd;
  static bool showingAd = false;

  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdConfig.instance.ads.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _interstitialAd = null;
        },
      ),
    );
  }

  static void showAd(BuildContext context, Function() onDismiss, { Function(Ad, double, PrecisionType, String)? onPaid }) {

    if (_interstitialAd != null) {
      _interstitialAd?.onPaidEvent =
          (Ad ad, double valueMicros, PrecisionType precision, String currencyCode) {
        final revenue = valueMicros / 1000000.0;
        final revenueString = "$revenue $currencyCode";
onPaid?.call(ad, valueMicros, precision, currencyCode);
        print('InterstitialAd paid event: $revenueString');
      };

      _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          Navigator.of(context).pop();
          ad.dispose();
          _interstitialAd = null;
          onDismiss();
          loadInterstitialAd();
        },
      );

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => BlankScreen()));
      _interstitialAd?.show();
    } else {
      AdmobInterstitial.loadInterstitialAd();
      onDismiss();
    }
  }
}
