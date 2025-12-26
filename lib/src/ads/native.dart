import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:simple_ads_manager/src/models/AdConfig.dart';

class AdMobNative extends StatefulWidget {
  final String adUnitId;
  final NativeTemplateStyle? nativeTemplateStyle;
  final double? height;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final VoidCallback? onLoaded;
  final Function(String error)? onFailed;
  final Function(double revenue)? onRevenue;

  const AdMobNative({
    super.key,
    required this.adUnitId,
    this.nativeTemplateStyle,
    this.height,
    this.loadingWidget,
    this.errorWidget,
    this.onLoaded,
    this.onFailed,
    this.onRevenue,
  });

  @override
  State<AdMobNative> createState() => _AdMobNativeState();
}

class _AdMobNativeState extends State<AdMobNative> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;
  bool _isFailed = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _nativeAd?.dispose();
    _nativeAd = null;
    _isLoaded = false;
    _isFailed = false;

    final nativeAd = NativeAd(
      adUnitId: AdConfig.getNative(widget.adUnitId),
      request: const AdRequest(),
      nativeTemplateStyle: widget.nativeTemplateStyle ??
          NativeTemplateStyle(
            templateType: TemplateType.medium,
          ),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }

          _nativeAd = ad as NativeAd;
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
            _nativeAd = null;
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

    _nativeAd = nativeAd;
    nativeAd.load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFailed) {
      return widget.errorWidget ?? const SizedBox.shrink();
    }

    if (!_isLoaded || _nativeAd == null) {
      if (widget.height != null) {
        return SizedBox(
          height: widget.height,
          child: widget.loadingWidget ?? const SizedBox.shrink(),
        );
      }
      return widget.loadingWidget ?? const SizedBox.shrink();
    }

    final templateType =
        widget.nativeTemplateStyle?.templateType ?? TemplateType.medium;


    final BoxConstraints constraints = templateType == TemplateType.small
        ? const BoxConstraints(
            minWidth: 320, // minimum recommended width
            minHeight: 90, // minimum recommended height
            maxWidth: 400,
            maxHeight: 120,
          )
        : const BoxConstraints(
            minWidth: 320, // minimum recommended width
            minHeight: 320, // minimum recommended height
            maxWidth: 400,
            maxHeight: 350,
          );

    return ConstrainedBox(
      constraints: constraints,
      child: AdWidget(ad: _nativeAd!),
    );
  }
}
