import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/src/models/AdConfig.dart';

class AdMobBanner extends StatelessWidget {
  final Function()? onLoaded;
  final Function(double revenue)? onRevenue;

  const AdMobBanner({super.key, this.onLoaded, this.onRevenue});

  Future<BannerAd?> _loadBanner() async {
    if (!AdConfig.enableBanner) {
      debugPrint('⚠️ Banner ads are disabled.');
      return null;
    }

    final completer = Completer<BannerAd>();

    final ad = BannerAd(
      adUnitId: AdConfig.getBanner(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // Call onLoaded
          onLoaded?.call();
          debugPrint('✅ BannerAd loaded.');
          completer.complete(ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('❌ BannerAd failed to load: $error');
          completer.complete(null);
        },
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {
          double revenue =
              valueMicros / 1000000; // convert micros to currency units
          debugPrint('💰 Banner revenue: $revenue $currencyCode');
          onRevenue?.call(revenue);
        },
      ),
    );

    ad.load();
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    if (!AdConfig.enableBanner) return Container();

    return FutureBuilder<BannerAd?>(
      future: _loadBanner(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final banner = snapshot.data!;
          return Container(
            width: banner.size.width.toDouble(),
            height: banner.size.height.toDouble(),
            child: AdWidget(ad: banner),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
