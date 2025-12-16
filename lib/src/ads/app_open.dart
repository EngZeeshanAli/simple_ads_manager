import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/src/models/AdConfig.dart';
import 'package:simple_ads_manager/src/utils/simple_overlay.dart';

class AdmobAppOpen {
  static AppOpenAd? appOpenAd;

  static void loadAppOpen() {
    if (AdConfig.enableAppOpen == false) {
      debugPrint('⚠️ App Open ads are disabled.');
      return;
    }
    AppOpenAd.load(
      adUnitId: AdConfig.getAppOpen(),
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          appOpenAd = ad;
          debugPrint('✅ App Open Ad loaded');
        },
        onAdFailedToLoad: (error) {
          appOpenAd = null;
          debugPrint('❌ App Open Ad failed to load: $error');
        },
      ),
    );
  }

  static void show(
      {required BuildContext context,
      Function(bool adShown)? onDismiss,
      Function(double revenue)? onRevenue}) {
    if (appOpenAd != null) {
      appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {},
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          appOpenAd = null;
          loadAppOpen();
        },
        onAdDismissedFullScreenContent: (ad) {
          SimpleOverlay.dismiss();
          ad.dispose();
          appOpenAd = null;
          loadAppOpen();
          onDismiss?.call(true);
        },
      );

      appOpenAd!.onPaidEvent = (Ad ad, double valueMicros,
          PrecisionType precision, String currencyCode) {
        double revenue =
            valueMicros / 1000000; // convert micros to currency units
        debugPrint('💰 App Open revenue: $revenue $currencyCode');
        onRevenue?.call(revenue);
      };
      SimpleOverlay.show(context);
      appOpenAd?.show();
    } else {
      onDismiss?.call(false);
      loadAppOpen();
    }
  }
}

class AppLifecycleReactorForAppOpen {
  void listenToAppStateChanges(
      {required BuildContext context,
      Function(bool adShown)? onDismiss,
      Function(double revenue)? onRevenue}) {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.forEach(
        (state) => _onAppStateChanged(context, state, onDismiss, onRevenue));
  }

  void _onAppStateChanged(BuildContext context, AppState appState,
      Function(bool adShown)? onDismiss, Function(double revenue)? onRevenue) {
    if (appState == AppState.foreground) {
      debugPrint("⚠️ App has come to foreground, show App Open Ad");

      AdmobAppOpen.show(
        context: context,
        onDismiss: onDismiss,
        onRevenue: onRevenue,
      );
    }
  }
}
