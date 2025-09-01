import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobNative extends StatefulWidget {
  final Function()? onLoaded;
  final String bannerAdUnit;
  final NativeTemplateStyle nativeTemplateStyle;
  final Function(Ad ad, double valueMicros, PrecisionType precision, String currencyCode)? onPaid;


  const AdMobNative(
      {super.key,
      required this.bannerAdUnit,
      required this.nativeTemplateStyle,
      this.onLoaded, this.onPaid});

  @override
  State<AdMobNative> createState() => _AdMobNativeState();
}

class _AdMobNativeState extends State<AdMobNative> {
  NativeAd? nativeAd;
  bool _nativeAdIsLoaded = false;

  @override
  void initState() {
    _loadAd();
    super.initState();
  }

  void _loadAd() {
    NativeAd(
        adUnitId: widget.bannerAdUnit,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
              nativeAd = ad as NativeAd;
            });
            widget.onLoaded?.call();
          },
          onPaidEvent: (Ad ad, double valueMicros, PrecisionType precision, String currencyCode) {
            final revenue = valueMicros / 1000000.0;
            final revenueString = "$revenue $currencyCode";
            debugPrint('NativeAd paid event: $revenueString');
            widget.onPaid?.call(ad, valueMicros, precision, currencyCode);
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: widget.nativeTemplateStyle)
      ..load();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return !_nativeAdIsLoaded ? const SizedBox() : AdWidget(ad: nativeAd!);
  }
}
