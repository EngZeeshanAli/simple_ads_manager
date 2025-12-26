# Changelog

## 1.0.0

### Added

- `SimpleAdsManager` class for centralized ad management.
- Support for all Google Mobile Ads types: Banner, Native, Interstitial, Rewarded, Rewarded
  Interstitial, App Open.
- `initAdsManager()` function to initialize ad units for both Android & iOS.
- `enableAds()` function to enable or disable specific ad types globally.
- `banner()` function to display banner ads.
- `native()` function to display native ads with customizable templates.
- `interstitial()` function to show interstitial ads with callbacks.
- `rewarded()` function to show rewarded ads with user reward callbacks.
- `rewardedInterstitial()` function to show rewarded interstitial ads with user reward callbacks.
- `appOpen()` function to manually show app open ads.
- `autoAppOpen()` function to automatically show app open ads on app resume.
- `isAvailable()` function to check availability of any ad type.
- Debug prints for ad events, revenue tracking, and ad completion.

### Changed

- Refactored ad loading for Banner and Native to use `FutureBuilder` and `ValueNotifier`.
- Unified rewarded and rewarded interstitial ad structure to match interstitial ad style.
- Updated main example for Flutter 3+ with Material3 support.

### Fixed

- Fixed banner and native ads revenue callback.
- Fixed app open ad lifecycle to show on resume.
- Fixed interstitial and rewarded ads callbacks to properly dispose ads and reload after dismissal.
- Resolved issues with outdated ad initialization and deprecated Google Mobile Ads APIs.

---