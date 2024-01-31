import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/src/models/AdConfig.dart';

class AdmobAppOpen {
  static AppOpenAd? _appOpenAd;

  static void loadAppOpen() {
    AppOpenAd.load(
      adUnitId: AdConfig.instance.ads.appOpen,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {},
      ),
    );
  }

  static void show() {
    if (_appOpenAd != null) {
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {},
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _appOpenAd = null;
          loadAppOpen();
        },
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _appOpenAd = null;
          loadAppOpen();
        },
      );
      _appOpenAd?.show();
    } else {
      loadAppOpen();
    }
  }
}

class AppLifecycleReactorForAppOpen {
  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  void _onAppStateChanged(AppState appState) {
    if (appState == AppState.foreground) {
      print("App is in foreground");
      AdmobAppOpen.show();
    }
  }
}
