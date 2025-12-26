import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/src/models/AdConfig.dart';

class AdMobBanner extends StatefulWidget {
  final String adUnitId;
  final AdSize? adSize;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final VoidCallback? onLoaded;
  final Function(String error)? onFailed;
  final Function(double revenue)? onRevenue;

  const AdMobBanner({
    super.key,
    required this.adUnitId,
    this.adSize,
    this.loadingWidget,
    this.errorWidget,
    this.onLoaded,
    this.onFailed,
    this.onRevenue,
  });

  @override
  State<AdMobBanner> createState() => _AdMobBannerState();
}

class _AdMobBannerState extends State<AdMobBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isFailed = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void didUpdateWidget(covariant AdMobBanner oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.adUnitId != widget.adUnitId ||
        oldWidget.adSize != widget.adSize) {
      _loadAd();
    }
  }

  void _loadAd() {
    _bannerAd?.dispose();
    _bannerAd = null;

    setState(() {
      _isLoaded = false;
      _isFailed = false;
    });

    final banner = BannerAd(
      adUnitId: AdConfig.getBanner(widget.adUnitId),
      size: widget.adSize ?? AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }

          _bannerAd = ad as BannerAd;

          setState(() {
            _isLoaded = true;
            _isFailed = false;
          });

          widget.onLoaded?.call();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) return;

          setState(() {
            _bannerAd = null;
            _isLoaded = false;
            _isFailed = true;
          });

          widget.onFailed?.call(error.message);
        },
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {
          final revenue = valueMicros / 1000000;
          widget.onRevenue?.call(revenue);
        },
      ),
    );

    _bannerAd = banner;
    banner.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFailed) {
      return widget.errorWidget ?? const SizedBox.shrink();
    }

    final adSize = widget.adSize ?? AdSize.banner;

    if (!_isLoaded || _bannerAd == null) {
      return SizedBox(
        width: adSize.width.toDouble(),
        height: adSize.height.toDouble(),
        child: widget.loadingWidget ?? const SizedBox.shrink(),
      );
    }

    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
