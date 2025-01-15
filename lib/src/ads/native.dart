import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobNative extends StatefulWidget {
  final Function()? onLoaded;
  final String bannerAdUnit;
  final NativeTemplateStyle nativeTemplateStyle;

  const AdMobNative(
      {super.key,
      required this.bannerAdUnit,
      required this.nativeTemplateStyle,
      this.onLoaded});

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
