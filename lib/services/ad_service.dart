import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static const String _appId = 'ca-app-pub-4420776878768276~1558821143';
  static const String _bannerAdId = 'ca-app-pub-4420776878768276/5633797528';
  static const String _interstitialAdId = 'ca-app-pub-4420776878768276/7741086118';

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  static String get appId => _appId;

  static String get bannerAdId {
    if (Platform.isAndroid) {
      return _bannerAdId;
    } else if (Platform.isIOS) {
      return _bannerAdId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdId {
    if (Platform.isAndroid) {
      return _interstitialAdId;
    } else if (Platform.isIOS) {
      return _interstitialAdId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );
  }

  static Future<InterstitialAd?> createInterstitialAd() async {
    InterstitialAd? interstitialAd;
    
    await InterstitialAd.load(
      adUnitId: interstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          print('Interstitial ad loaded');
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
    
    return interstitialAd;
  }

  static void showInterstitialAd(InterstitialAd? ad, {VoidCallback? onAdClosed}) {
    if (ad != null) {
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          if (onAdClosed != null) {
            onAdClosed();
          }
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('Interstitial ad failed to show: $error');
          ad.dispose();
          if (onAdClosed != null) {
            onAdClosed();
          }
        },
      );
      ad.show();
    } else {
      print('Interstitial ad is not ready');
      if (onAdClosed != null) {
        onAdClosed();
      }
    }
  }
}

