import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/AdConfig.dart';

class AdmobInterstitial {
  static InterstitialAd? _interstitialAd;

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

  static void showAd(Function() onDismiss) {
    if (_interstitialAd != null) {
      _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          onDismiss();
          loadInterstitialAd();
        },
      );
      _interstitialAd?.show();
    } else {
      AdmobInterstitial.loadInterstitialAd();
      onDismiss();
    }
  }
}
