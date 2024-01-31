import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobBanner extends StatefulWidget {
  AdMobBanner({super.key, required this.bannerAdUnit});

  String bannerAdUnit;

  @override
  State<AdMobBanner> createState() => _AdMobBannerState();
}

class _AdMobBannerState extends State<AdMobBanner> {
  BannerAd? _bannerAd;

  void _createBanner() {
    BannerAd(
      adUnitId: widget.bannerAdUnit,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void initState() {
    _createBanner();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _bannerAd != null
        ? Container(
            width: _bannerAd?.size.width.toDouble(),
            height: _bannerAd?.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          )
        : Container();
  }
}
