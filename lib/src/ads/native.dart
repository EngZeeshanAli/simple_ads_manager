import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/src/models/AdConfig.dart';

class AdMobNative extends StatelessWidget {
  final NativeTemplateStyle style;
  final Function()? onLoaded;
  final Function(double revenue)? onRevenue;
  final ValueNotifier<NativeAd?> _adNotifier = ValueNotifier(null);

  AdMobNative({
    super.key,
    required this.style,
    this.onLoaded,
    this.onRevenue,
  }) {
    _load();
  }

  void _load() {
    if (!AdConfig.enableNative) {
      debugPrint('⚠️ Native ads are disabled.');
      return;
    }

    debugPrint('⚠️ Loading Native Ad...');
    final nativeAd = NativeAd(
      adUnitId: AdConfig.getNative(),
      request: const AdRequest(),
      nativeTemplateStyle: style,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('✅ NativeAd loaded.');
          _adNotifier.value = ad as NativeAd;
          onLoaded?.call();
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ NativeAd failed to load: $error');
          ad.dispose();
        },
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {
          double revenue = valueMicros / 1e6;
          debugPrint('💰 Native Ad revenue: $revenue $currencyCode');
          onRevenue?.call(revenue);
        },
      ),
    );

    nativeAd.load();

    // Dispose previous ad if reloaded
    _adNotifier.addListener(() {
      if (_adNotifier.value != nativeAd) {
        _adNotifier.value?.dispose();
        debugPrint('🗑️ Previous NativeAd disposed.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<NativeAd?>(
      valueListenable: _adNotifier,
      builder: (context, ad, _) {
        if (ad == null) return const SizedBox();
        final constraints = style.templateType == TemplateType.small
            ? const BoxConstraints(
                minWidth: 320,
                minHeight: 90,
                maxWidth: 400,
                maxHeight: 100,
              )
            : const BoxConstraints(
                minWidth: 320,
                minHeight: 320,
                maxWidth: 400,
                maxHeight: 350,
              );

        return ConstrainedBox(
          constraints: constraints,
          child: Center(child: AdWidget(ad: ad)),
        );
      },
    );
  }
}
