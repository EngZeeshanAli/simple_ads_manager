import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/src/models/ad_config.dart';
import 'package:simple_ads_manager/src/utils/simple_overlay.dart';

class AdmobAppOpen {
  static bool _isShowing = false;
  static DateTime? _lastShown;
  static Duration cooldown = const Duration(minutes: 1);

  static void loadAndShow({
    required String adUnitId,
    required BuildContext context,
    Function()? onShown,
    Function()? onDismissed,
    Function(String error)? onFailed,
    Function(double revenue)? onRevenue,
  }) {
    // Prevent multiple simultaneous shows
    if (_isShowing) return;

    // Cooldown check
    if (_lastShown != null &&
        DateTime.now().difference(_lastShown!) < cooldown) {
      return;
    }

    AppOpenAd.load(
      adUnitId: AdConfig.getAppOpen(adUnitId),
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ App Open Ad loaded');

          ad.onPaidEvent = (
            Ad ad,
            double valueMicros,
            PrecisionType precision,
            String currencyCode,
          ) {
            final revenue = valueMicros / 1000000;
            debugPrint('💰 App Open revenue: $revenue $currencyCode');
            onRevenue?.call(revenue);
          };

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              _isShowing = true;
              _lastShown = DateTime.now();
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
          );

          SimpleOverlay.show(context);
          ad.show();
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ App Open Ad failed to load: $error');
          onFailed?.call(error.message);
        },
      ),
    );
  }
}

class AppLifecycleReactorForAppOpen {
  void listenToAppStateChanges({
    required String adUnitId,
    required BuildContext context,
    Function()? onShown,
    Function()? onDismissed,
    Function(String error)? onFailed,
    Function(double revenue)? onRevenue,
  }) {
    AppStateEventNotifier.startListening();

    AppStateEventNotifier.appStateStream.listen((state) {
      if (state == AppState.foreground) {
        debugPrint("⚠️ App foreground → App Open");

        AdmobAppOpen.loadAndShow(
          adUnitId: adUnitId,
          context: context,
          onShown: onShown,
          onDismissed: onDismissed,
          onFailed: onFailed,
          onRevenue: onRevenue,
        );
      }
    });
  }
}
