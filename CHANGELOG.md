# Changelog

## 1.1.0

### Added

- Preload support for Interstitial ads.
- Preload support for Rewarded Interstitial ads.
- `showPreloadedInterstitial()` method.
- `showPreloadedRewardedInterstitial()` method.
- Availability getters:
    - `isInterstitialReady`
    - `isRewardedReady`
    - `isRewardedInterstitialReady`
- App Open cooldown control via `setAppOpenCooldown()`.
- Unified `loadAndShow` API pattern for fullscreen ads.
- Explicit `adUnitId` parameter for all ad calls.

---

### Changed

- Removed `initAdsManager()` in favor of simplified `init()`.
- Removed `enableAds()` global toggles.
- Removed old generic `isAvailable(adType)` usage.
- Refactored ad lifecycle handling.
- Refactored fullscreen ad disposal and reload flow.
- Improved preload stability and show rate optimization.
- Standardized revenue callback handling across all ad types.

---

### Fixed

- Fixed duplicate ad show edge cases.
- Fixed improper ad disposal after dismissal.
- Fixed multiple load calls during preload.
- Fixed App Open lifecycle resume behavior.
- Improved memory safety.

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