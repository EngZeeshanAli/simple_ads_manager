
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/src/ads/blank_screen.dart';
import 'package:simple_ads_manager/src/models/AdConfig.dart';

class AdmobAppOpen {
  static AppOpenAd? _appOpenAd;
  static bool showingAd = false;

  static void loadAppOpen() {
    AppOpenAd.load(
      adUnitId: AdConfig.instance.ads.appOpen,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          print("App Open Failed to Load :  $error");
        },
      ),
    );
  }

  static void show(BuildContext context, Function() onDismiss) {
    if (_appOpenAd != null) {
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {},
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _appOpenAd = null;
          loadAppOpen();
        },
        onAdDismissedFullScreenContent: (ad) {
          Navigator.of(context).pop();
          ad.dispose();
          _appOpenAd = null;
          loadAppOpen();
          onDismiss();
        },
      );
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => BlankScreen()));
      _appOpenAd?.show();
    } else {
      onDismiss();
      loadAppOpen();
    }
  }
}

class AppLifecycleReactorForAppOpen {
  void listenToAppStateChanges(BuildContext context,) {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(context,state));
  }

  void _onAppStateChanged(BuildContext context,AppState appState) {
    if (appState == AppState.foreground) {
      print("App is in foreground");
      AdmobAppOpen.show(context,(){});
    }
  }
}
